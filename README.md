**Analyzing Databricks spark logs on Azure**

Analyzing spark logs on Azure Databricks can be challanging especially when we have more than one cluster and different pipelines and/or stages of pipelines run on different clusters. This is an attempt to centralize the logs to a time-series explorer for faster analysis. The current setup wants a fixed location and tails the log files from both driver and executor.

Here are the steps involved:

1. Mount a blob container to databricks workspace. Make sure that both are in the same Azure region

2. Point the databricks jobs and/or clusters to write logs to the blob mounted via dbfs. This is done via the 'cluster_log_conf' parameter in the rest api or from the databricks UI

3. Create a VM and install logstash (can also use docker with ACI or AKS)

       Logstash setup instructions here
	    https://www.elastic.co/guide/en/logstash/current/installing-logstash.html

       Install logstash kusto plugin
		https://github.com/Azure/logstash-output-kusto

4. Fuse mount blob container on to the VM or as docker volume
        https://docs.microsoft.com/en-us/azure/storage/blobs/storage-how-to-mount-container-linux

       Sample config script is at fuseconnection.cfg and the mount script at fusemount.sh

5. Create a kusto instance in the same region as Databricks clusters and blob. Create the relevant database and tables.

       Scripts is at kusto_create_table.txt 

6. Update the logstash config with the relevant parameters

       Sample script at spark_logstash.conf

7. Run log stash.  You may need to tweak with JVM heap if needed

       Sample script is at run_logstash.sh.

8. Run your spark jobs/clusters and now you can query from kusto the data


**Below are a few queries**

You can find the full query syntax here https://docs.microsoft.com/en-us/azure/kusto/query/


Query to list 10 sample rows:

	mysparklogs
	| limit 10
 

Query to count total errors seen:

	mysparklogs
	| where loglevel == "ERROR"
	| count

Query to get count of errors per cluster, per class:

	mysparklogs
	| where loglevel == "ERROR"
	| summarize event_count=count() by class, loglevel, jobcluster = tostring(split(path,"/")[5]), logmessage 
	| order by event_count , class , jobcluster
	| render table 








