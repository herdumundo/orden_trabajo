 <%@ Page Language="C#" AutoEventWireup="true"%>

 <% @Import Namespace="System" %>
<% @Import Namespace="Libreria" %>
<% @Import Namespace="System.Data.SqlClient" %>

<% //DataSet ds;
    SqlCommand rs;
    SqlDataReader dr;
   // String usuario = Request.Params["txt_usuario"];
    String fecha = Request.Params["fecha"];
    String fecha_fin = Request.Params["fecha_fin"];
        String estado_doc = Request.Params["estado"];

    String id_usuario = Session["id_usuario"].ToString();
    String estado_formateado = "";
    String conn = Global.conn;
    SqlConnection cnn = new SqlConnection(conn);
    cnn.Open(); %>
 
<style>
        .alternar:hover{ background-color:#ffcc66;}
    </style>

 <table  id="tabla_informe" class="table"   data-row-style="rowStyle" data-toggle="table" data-click-to-select="true">
              
             <tr style="background-color:rgba(255, 14, 14, 0.57);" >
         
 
            <th>NRO.</th>
            <th>MAQUINA</th>
            <th>DESCRIPCIÓN</th>
            <th>FECHA PROGRAMADA DE INICIO</th>
            <th>FECHA PROGRAMADA DE FINALIZACION</th>
            <th>DETALLE</th>
            <th>ESTADO</th>
            <th>FECHA</th>
                          
   
    </tr> 
   
   <%

       try
       {
           //status -2 = a pendiente 
           rs = new SqlCommand("  select os.descrption,os.status,os.subject,os.callid,sc.U_Id_Usuario, " +
               "convert(varchar,os.createdate,103) as fecha ,maq.resname as maquina  " +
               "from oscl os inner join scl5 sc on os.callID=sc.SrvcCallId    " +
               "inner join oclg oc on oc.ClgCode=sc.ClgID  " +
               "inner join orsc maq on maq.rescode=os.U_recurso     " +
               "where    sc.Line=0   and sc.U_Id_Usuario='"+id_usuario+"' " +
               "and convert(date,os.createdate) between '"+fecha+"' and '"+fecha_fin+"' and os.status ="+estado_doc+" ", cnn);


           dr = rs.ExecuteReader();
           while (dr.Read())
           {     String descripcion2 = "";
               String fecha_Desde = "";
               String fecha_hasta = "";

               String id= dr["callid"].ToString();
               String descripcion= dr["subject"].ToString();
               String estado= dr["status"].ToString();
               String FECHA= dr["fecha"].ToString();
               String obss= dr["descrption"].ToString();
               String MAQUINA= dr["maquina"].ToString();
                
               if (descripcion.Contains("|"))
               {
                   String[] descripciones = descripcion.Split('|');
                   descripcion2 = descripciones[0];
                   fecha_Desde=descripciones[1];
                   fecha_hasta=descripciones[2];
               }
               else
               {

                   descripcion2 = descripcion;

               }

               if (estado.Equals("1"))
               {
                   estado_formateado = "PENDIENTE";
               }
               else if(estado.Equals("2"))
               {
                   estado_formateado = "PENDIENTE APROBACION JEFE MANTENIMIENTO";
               }
               else if(estado.Equals("3"))
               {
                   estado_formateado = "PENDIENTE ASIGNACION DE OPERARIOS";
               }
               else if(estado.Equals("4"))
               {
                   estado_formateado = "PENDIENTE DE RESOLUCION";
               }
               else if(estado.Equals("5"))
               {
                   estado_formateado = "PENDIENTE DE VERIFICACION JEFE DE AREA";
               }

               else if(estado.Equals("6"))
               {
                   estado_formateado = "CERRADO";
               }
               else
               {
                   estado_formateado = "CANCELADO";
               }
               %>
                        <tr id="<%=id%>"   >  
                          <td><%=id%></td>
                             <td><%=MAQUINA%></td>
                        <td><%=descripcion2%></td>
                            <td><%=fecha_Desde%></td>
                             <td><%=fecha_hasta%></td>
                        <td><%=obss%></td>  
                        <td><%=estado_formateado%></td>   
                       <td><%=FECHA%></td>  
                        </tr>   
      <% 

                        }
                        dr.Close();
                    }
                    catch (Exception ex)
                    {   } 
        
 
%>        </table> 
 
