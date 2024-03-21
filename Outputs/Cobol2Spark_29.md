
```python
 from pyspark.sql import SparkSession

# Create a SparkSession
spark = SparkSession.builder.appName('app').getOrCreate()

# Load the files into DataFrames
ARQPARM_df = spark.read.text("path_to_ARQPARM_file")
ARQSORT_df = spark.read.text("path_to_ARQSORT_file")
DIMESTIP_df = spark.read.text("path_to_DIMESTIP_file")
ARQFTP_df = spark.read.text("path_to_ARQFTP_file")
 ```


 ```python
 from pyspark.sql import SparkSession

# Create a SparkSession
spark = SparkSession.builder.appName("example").getOrCreate()

# Read data from a CSV file
df = spark.read.csv("path_to_your_file.csv", header=True, inferSchema=True)

# Perform some data manipulations
df = df.filter(df["column_name"] > 0)

# Write the data back to a CSV file
df.write.csv("path_to_output_file.csv")
 ```


 ```python
 from pyspark.sql import SparkSession
from pyspark.sql.functions import col

spark = SparkSession.builder.getOrCreate()

# Read input data
arqparm = spark.read.text("path_to_arqparm")
arqftp = spark.read.text("path_to_arqftp")

# Process data
processed = arqparm.filter(col("PERIODICIDADE") == 'D').filter(col("DATA-PROC") != col("DATA-PROX"))

# Write output data
processed.write.text("path_to_output")

# Close SparkSession
spark.stop()
 ```
