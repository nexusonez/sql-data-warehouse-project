
# Data Dictionary for Gold Layer
## Overview
The Gold Layer is the business-level data representation, structured to support analytical and reporting use cases. It consists of <strong> dimension tables</strong> and <strong> fact tables</strong> for specific business metrics.

<li style="list-style-type: decimal;"> gold.dim_customers
  <ul style="list-style-type: circle;">
    <li><strong>Purpose: </strong> Store customer details enriched with demographic and geographic data.</li>
    <li><strong>Columns: </strong> 
    <table>
      <thead>
        <th>Column Name</th>
        <th>Data type</th>
        <th>Descriptions</th>
      </thead>
      <tr>
        <td>customer_key</td>
        <td>INT</td>
        <td>Surrogate key uniquely identifying each customer record in the dimension table.</td>
      </tr>
      <tr>
        <td>customer_id</td>
        <td>INT</td>
        <td>Unique numerical identifier assigned to each customer.</td>
      </tr>
      <tr>
        <td>customer_number</td>
        <td>NVARCHAR(50)</td>
        <td>Alpha numeric identifier representing the customer, used for tracking and referencing</td>
      </tr>
      <tr>
        <td>first_name</td>
        <td>NVARCHAR(50)</td>
        <td>The customer's first_name as recorded in the system.</td>
      </tr>
      <tr>
        <td>last_name</td>
        <td>NVARCHAR(50)</td>
        <td>The customer's first_name or family name.</td>
      </tr>
      <tr>
        <td>country</td>
        <td>NVARCHAR(50)</td>
        <td>The country of residence of the customer(e.g. United Kingdom).</td>
      </tr>
      <tr>
        <td>marital_status</td>
        <td>NVARCHAR(50)</td>
        <td>The marital status of the customer. (e.g. 'Married', 'Single').</td>
      </tr>
      <tr>
        <td>gender</td>
        <td>NVARCHAR(50)</td>
        <td>The gender of the customer(e.g. 'Male', 'Female', 'n/a').</td>
      </tr>
      <tr>
        <td>birthdate</td>
        <td>DATE</td>
        <td>The date of birth of the customer, formatted as YYYY-MM-DD (e.g., 1971-10-06).</td>
      </tr>  
      <tr>
        <td>create_date</td>
        <td>DATE</td>
        <td>The date and time when the customer record was created in the system.</td>
      </tr>  
    </table>
    </li>
    
  </ul>
</li>
<li style="list-style-type: decimal;"> gold.dim_products
  <ul style="list-style-type: circle;">
    <li><strong>Purpose: </strong> Provides information about the products and their attributes.</li>
    <li><strong>Columns: </strong> 
    <table>
      <thead>
        <th>Column Name</th>
        <th>Data type</th>
        <th>Descriptions</th>
      </thead>
      <tr>
        <td>product_key</td>
        <td>INT</td>
        <td>Surrogate key uniquely identifying each product record in the product dimension table.</td>
      </tr>
      <tr>
        <td>product_id</td>
        <td>INT</td>
        <td>A unique numerical identifier assigned to each product for internal tracking and referencing.</td>
      </tr>
      <tr>
        <td>product_number</td>
        <td>NVARCHAR(50)</td>
        <td>A structured alphanumeric identifier representing the product, often used for categorization or inventory.</td>
      </tr>
      <tr>
        <td>category_id</td>
        <td>NVARCHAR(50)</td>
        <td>A unique identifier for the product's category, linking to its high-level classification.
      <tr>
        <td>category</td>
        <td>NVARCHAR(50)</td>
        <td>The broader classification of the product (e.g., Bikes, Components) to group related items.</td>
      </tr>
      <tr>
        <td>subcategory</td>
        <td>NVARCHAR(50)</td>
        <td>A more detailed classification of the product within the category, such as product type.</td>
      </tr>
      <tr>
        <td>maintenance</td>
        <td>NVARCHAR(50)</td>
        <td>Indicates whether the product requires maintenance (e.g., 'Yes', 'No').</td>
      </tr>
      <tr>
        <td>cost</td>
        <td>NVARCHAR(50)</td>
        <td>The cost or base price of the product, measured in monetary units.</td>
      </tr>
      <tr>
        <td>product_line</td>
        <td>DATE</td>
        <td>The specific product line or seroes to which the product belongs (e.g., Road, Mountain, Others).</td>
      </tr>  
      <tr>
        <td>start_date</td>
        <td>DATE</td>
        <td>The date when the product became available for sale, used, or stored in the system.</td>
      </tr>  
    </table>
    </li>
    
  </ul>
</li>
<li style="list-style-type: decimal;"> gold.fact_sales
  <ul style="list-style-type: circle;">
    <li><strong>Purpose: </strong> Stores transactional sales data for analytical purposes.</li>
    <li><strong>Columns: </strong> 
    <table>
      <thead>
        <th>Column Name</th>
        <th>Data type</th>
        <th>Descriptions</th>
      </thead>
      <tr>
        <td>order_number</td>
        <td>NVARCHAR(50)</td>
        <td>A unique alphanumeric identifier for each sales order (e.g., 'SO54496').</td>
      </tr>
      <tr>
        <td>product_key</td>
        <td>INT</td>
        <td>Surrogate key linking the order to the product dimension table.</td>
      </tr>
      <tr>
        <td>customer_key</td>
        <td>INT</td>
        <td>Surrogate key linking the order to the customer dimension table.</td>
      </tr>
      <tr>
        <td>order_date</td>
        <td>DATE</td>
        <td>The date when the order was placed.
      <tr>
        <td>shipping_date</td>
        <td>DATE</td>
        <td>The date when the order was shipped to the customer.</td>
      </tr>
      <tr>
        <td>due_date</td>
        <td>DATE</td>
        <td>The date when the order payment was due.</td>
      </tr>
      <tr>
        <td>sales_amount</td>
        <td>INT</td>
        <td>The total monetary value of the sale for the line item, in whole currency units (e.g., 25).</td>
      </tr>
      <tr>
        <td>quantity</td>
        <td>INT</td>
        <td>The number of units of the product ordered for the line item (e.g., 1).</td>
      </tr>
      <tr>
        <td>price</td>
        <td>INT</td>
        <td>The price per unit of the product for the line item, in whole currency units (e.g., 25).</td>
      </tr>  
    </table>
    </li>
    
  </ul>
</li>



