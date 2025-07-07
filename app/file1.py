# Databricks notebook source
from pyspark import SparkConf, SparkContext
import os

# COMMAND ----------
directory = os.getcwd()
filepath = os.path.join(directory,'data')

#print(filepath)

conf = SparkConf().setAppName("Read File")

# COMMAND ----------

sc = SparkContext.getOrCreate(conf=conf)

# COMMAND ----------

text = sc.textFile(f'{filepath}/sample.txt')

# COMMAND ----------

print('\n\n\n')
print(text.collect())
print('\n\n\n')

