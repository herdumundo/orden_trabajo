<%@ Page Language="C#" AutoEventWireup="true" %>
<% @Import Namespace="System" %>
<% @Import Namespace="WebApplication1" %>
<% @Import Namespace="System.Data.SqlClient" %>

<% //DataSet ds;
    SqlCommand rs;
    SqlDataReader dr;
    String id_grilla = Request.Params["id"];
      
 
     String conn = Global.conn;
       SqlConnection cnn = new SqlConnection(conn);
         cnn.Open(); %>

        <style>
        .alternar:hover{ background-color:#ffcc66;}
        </style>


   <%

       try
       {

           rs = new SqlCommand("select descrption from oscl with(nolock) where callid="+id_grilla.Trim()+"", cnn);

      
           dr = rs.ExecuteReader();
           while (dr.Read())
           {
                
               String descripcion= dr["descrption"].ToString();
               
               %>
                        
                       
                        <%=descripcion%> 
                        
                          
      <% 

              }
              dr.Close();

          }
          catch (Exception ex)
          {



          }



          cnn.Close();
%>      

  
    
   
    
               
 