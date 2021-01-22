<%@ Page Language="C#" AutoEventWireup="true"%>

 <% @Import Namespace="System" %>
<% @Import Namespace="WebApplication1" %>
<% @Import Namespace="System.Data.SqlClient" %>

<% //DataSet ds;
    
    SqlCommand rs;
    SqlDataReader dr;
    String usuario = Request.Params["txt_usuario"];
    String id_usuario = Session["id_usuario"].ToString();
    String estado_formateado = "";
    String conn = Global.conn;
    SqlConnection cnn = new SqlConnection(conn);
    cnn.Open();

     %>








<style>
        .alternar:hover{ background-color:#ffcc66;}
    </style>

 <table  id="tabla_informe" class="table table-striped table-bordered"   data-row-style="rowStyle" data-toggle="table" data-click-to-select="true">
              
     <thead>

     
             <tr style="background-color:rgba(255, 14, 14, 0.57);" >
             <th>NRO.</th>
            <th>MAQUINA</th>
            <th>DESCRIPCIÓN</th>
            <th>DETALLE</th>
            <th>FECHA DE CREACION</th>
            <th>ESTADO</th>
            <th>NOTAS</th>
               
                       
   
    </tr> 
    </thead>  
   <%

       try
       {
           //status -2 = a pendiente 
           rs = new SqlCommand("select os.descrption,os.status,os.subject,os.callid,sc.U_Id_Usuario ,maq.resname as maquina,os.createdate, " +
               "oc2.notes from oscl os with(nolock) inner join scl5 sc on os.callID=sc.SrvcCallId    inner join scl5 sc2 on os.callID=sc2.SrvcCallId    " +
               "inner join oclg oc with(nolock) on oc.ClgCode=sc.ClgID  inner join oclg oc2 with(nolock) on oc2.ClgCode=sc2.ClgID  and oc2.closed='N' " +
               "left outer join orsc maq with(nolock) on maq.rescode=os.U_recurso       where   sc.Line=0   and os.status in (1,2,3,4,5)  and sc.U_Id_Usuario='"+id_usuario+"'    ", cnn);


           dr = rs.ExecuteReader();
           while (dr.Read())
           {
               String descripcion = "";

               String id= dr["callid"].ToString();
               descripcion= dr["subject"].ToString();
               String MAQUINA= dr["maquina"].ToString();



               String estado= dr["status"].ToString();
               String obss= dr["descrption"].ToString();
               if (estado.Equals("1"))
               {
                   estado_formateado = "PENDIENTE";
               }
               else if (estado.Equals("2"))
               {
                   estado_formateado = "PENDIENTE APROBACION JEFE MANTENIMIENTO";
               }
               else if (estado.Equals("3"))
               {
                   estado_formateado = "PENDIENTE ASIGNACION OPERARIOS";
               }
               else if (estado.Equals("4"))
               {
                   estado_formateado = "PENDIENTE PENDIENTE RESOLUCION";
               }else if (estado.Equals("5"))
               {
                   estado_formateado = "PENDIENTE VERIFICACION ENCARGADO AREA";
               }
               %>
                        <tr id="<%=id%>">  
                          <td><%=id%></td>
                             <td><%=MAQUINA%></td>
                        <td><%=descripcion%></td>
                        <td><%=obss%></td>  
                       <td><%= dr["createdate"].ToString()%></td>                         
                        <td><%=estado_formateado%></td>  
                        <td> <textarea readonly style="width:500px; height:80px" class="form - control"  > <%=dr["notes"].ToString()%></textarea></td>  
                       
                         </tr>   
      <% 

                        }
                        dr.Close();
                    }
                    catch (Exception ex)
                    {   } 
        
 
%>        </table> 
 
<%cnn.Close();%>