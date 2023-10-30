
## Project Description

This repository contains the code for a project that involves visualizing product and economics metrics using the Superset BI system. It includes all the necessary datasets, SQL scripts, and instructions to run the project. The project is fully completed.

## Project Technologies

Docker, Postgres, Apache Superset.

## Project Aim and Possible Usage

The primary objective of this project is to demonstrate the connection between the datasets and the types of charts used to visualize them. The visualizations provide insights into the user base, revenue generation, and retention rates, enabling you to make informed decisions for your business.

Additionally, this project serves as a summary of all the information on using databases, writing complex SQL scripts, and data visualization during my studies. It can be used as a case study to understand how to utilize all the mentioned technologies together.

![image](https://ibb.co/z7cX9gY)

## TABLE OF CONTENTS:

* [Installation](#installation)
* [Data Processing](#data-processing)
* [Data Visualialization](#data-visualization)
	
## Installation:

### Install Docker: 

To install docker locally on Linux machine follow the official instructions: https://docs.docker.com/engine/install/ubuntu/.
No further modifications to these commands are required.
	
### Configure network:
	
Here we need to create network, so that different APP Containers we deploy could talk to each other:

	docker network create app_net
		
### Configure Postgres Image:

We need to create a volume to store data of our Postgres Database, so that we don't lose data, working with our datasets from DB later.
		
	docker volume create postgres_volume

	sudo docker run -d \
		--name postgres_1 \
		-e POSTGRES_PASSWORD=postgres_admin \
		-e POSTGRES_USER=postgres_admin \
		-e POSTGRES_DB=test_app \
		-v postgres_volume:/var/lib/postgresql/data \
		--net=app_net \
		-p 5432:5432 \
		postgres:14	
	
### Configure Superset:

Finally, we need to specify app-net, so that our Database and BI System could talk to each other.

	docker volume superset_volume
	
	sudo docker run -d \
		--net=app_net -p 80:8088 \
		-e "SUPERSET_SECRET_KEY=YOUR_SECRET_KEY" \
		--name superset apache/superset
	
Further commands needed to run Superset are provided at the official documentation: https://hub.docker.com/r/apache/superset.
	They require no modifications.
	
## Data Processing:

### Dataset description:

This dataset contains data on orders, users, and other information of a food delivery tech company. The data was randomly generated.

### Loading data to Postgres:

You can load data into Postgres using a data management system like DBeaver or the command line. Since built-in data management tools can struggle with processing csv files correctly, we import all timestamp columns and array data as varchar type and later convert them using DML operations. The rest of the data can be imported as integer type.
		
Then we run DML commands to process CSV data in the following order:

* The "clean order data" script formats the data for further conversion to array data type.
* The "change order data type" script converts the data to array data type.
* The "change order creation time" script converts the imported timestamps in varchar format to the proper timestamp format.
		
## Data Visualialization:

### Creating Virtual Datasets:

To visualize the data, we first need to create Virtual Datasets, which will serve as base for our Charts. To do this we go to SQL-Lab editor and run the further explained SQL-queries provided in the repository. Then we proceed to creating Charts from its contents.

The Virtual Datasets are based on scripts from the "SQL scripts" folder.
	
* #### Virtual Dataset 1: "Paying users and Total orders"  </strong>

	This dataset should be created based on the script "Paying users and Total users" and helps you to create a series of "Big Number with Trendline" charts at the top of the Dashboard. The purpose of these charts is to show the total number of paying users and the total number of orders over a period of time. The trendline helps you to identify the growth or decline of the user base.
	
* #### Virtual Dataset 2: New and Total Users

	This dataset should be created based on the script "New and Total Users" and helps you to create a "Mixed Chart" for the left side of the visualization. The chart shows the number of new users and the total number of users over a period of time. The line graph represents the total number of users, while the column graph represents the number of new users. This visualization helps you to understand the growth of the user base and the impact of new users on the total user count.

* #### Virtual Dataset 3: ARPU, ARPPU, AOV
	
	This dataset should be created based on the script "ARPU, ARPPU, AOV" and helps you to create a "Line Chart" for the right side of the visualization. The chart shows the average revenue per user (ARPU), average revenue per paying user (ARPPU), and the average order value (AOV) over a period of time. This visualization helps you to understand the revenue generated from the user base and the impact of new paying users on the overall revenue.

* #### Virtual Dataset 4: Retention calculation
	
	This dataset should be created based on the script "Retention calculation" and helps you to create a "Pivot table" for the center of the visualization. The table shows the retention rate of the users, i.e., the percentage of users who remain active after a certain period of time. This visualization helps you to understand the user retention rate and the factors that contribute to it.
	
### Applying CSS Styles:

By default, Superset aligns all the information in the Pivot table chart cells by the left side. 
It can be inconvenient, so we can align it at the center to increase chart's usability and create more aesthetic look.
File "pivot_table.css" contains CSS style for performing this operation.
	
You can learn more about working with styles from the official blog: https://preset.io/blog/customizing-superset-dashboards-with-css/
	
## Thanks:
	
I would like to thank Anton Sidorin - a backend developer from Karpov Cources for providing detailed instructions on running Docker Containers.
	
Enjoy the final result! A full-resolution screenshot can also be found in this repository.