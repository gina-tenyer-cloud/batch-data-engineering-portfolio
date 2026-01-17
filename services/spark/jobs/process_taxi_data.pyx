from pyspark.sql import SparkSession
from pyspark.sql.functions import to_timestamp, col

spark = SparkSession.builder.appName("TaxiPipeline").getOrCreate()

raw_path = "s3a://raw/nyc_taxi_sample.csv"
bronze_path = "s3a://bronze/taxi_parquet"
silver_path = "s3a://silver/taxi_clean"
gold_path = "s3a://gold/taxi_daily_revenue"

df = spark.read.option("header", True).csv(raw_path)

df.write.mode("overwrite").parquet(bronze_path)

df2 = (
    df.withColumn("pickup_datetime", to_timestamp("pickup_datetime"))
      .withColumn("fare_amount", col("fare_amount").cast("double"))
      .withColumn("trip_distance", col("trip_distance").cast("double"))
)

df2.write.mode("overwrite").parquet(silver_path)

gold = (
    df2.groupBy(df2.pickup_datetime.cast("date").alias("date"))
       .sum("fare_amount")
       .withColumnRenamed("sum(fare_amount)", "total_fare")
)

gold.write.mode("overwrite").parquet(gold_path)

spark.stop()


