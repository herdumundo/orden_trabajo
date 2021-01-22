<%@ Page Language="C#" AutoEventWireup="true"   %>

 <% @Import Namespace="System" %>
<% @Import Namespace="WebApplication1" %>
<% @Import Namespace="System.Data.SqlClient" %>

<% //DataSet ds;
    SqlCommand rs,rs2;
    SqlDataReader dr,dr2;
             if (Session["nombre_usuario"] == null)
    {
         Response.Redirect("login.aspx");
       
    } 
    String usuario = Request.Params["txt_usuario"];
    String id_usuario =Session["id_usuario"].ToString();
    String area = Session["area"].ToString();
    String conn = Global.conn;

    String conn_gm = Global.gm_conn;
    SqlConnection cnn_gm = new SqlConnection(conn_gm);
    SqlConnection cnn = new SqlConnection(conn);
    cnn.Open();
    String area_formato = "";
    String estado_formateado = "";
  
    cnn_gm.Open();

  

    %>



 
<style>
     .alternar:hover{ background-color:#ffcc66;}
    </style>

<form id="grilla_ot" method="post">
  <table  id="tabla_informe" class="table table-striped table-bordered"   data-row-style="rowStyle" data-toggle="table" data-click-to-select="true">
              <thead><tr style="background-color:rgba(255, 14, 14, 0.57);" >
         
 
                 <th>NRO.</th>
                 <th>MAQUINA</th>
                 <th>DESCRIPCIÓN</th>
                 <th>DETALLE</th>
                 <th>NOTAS</th>
                 <th>AREA</th>
                 <th>FECHA DE CREACION</th>
                 <th>ACCION</th>
                 
            </tr> 
           </thead>
             
                  <%

                      try
                      {
                          //status -2 = a pendiente 
                          rs = new SqlCommand("  select t1.u_usuario ,t0.descrption,t0.subject,t0.callid,  " +
                              "t3.Name ,maq.resname as maquina,convert(varchar,t0.createdate,103) as createdate , oc.notes " +
                              "from oscl t0 with(nolock) " +
                              "inner join scl5 t1 with(nolock) on t0.callid=t1.SrvcCallId  " +
                              "inner join oclg t2 with(nolock) on t1.ClgID=t2.ClgCode " +
                              "inner join osco t3 with(nolock) on t0.origin=t3.originid " +
                              "left outer join orsc maq with(nolock) on maq.rescode=t0.U_recurso " +
                              "inner join scl5 sc2 on t0.callID=sc2.SrvcCallId  inner join oclg oc  with(nolock) on oc.ClgCode=sc2.ClgID  " +
                              " and oc.closed='N' where  t0.status=4   and t2.U_Id_Asignado="+id_usuario+"", cnn);


                          dr = rs.ExecuteReader();
                          while (dr.Read())
                          {


                              String est_detalle=Regex.Replace(dr["descrption"].ToString(), @"\r\n?|\n", "-");

               %>
                        <tr id="<%=dr["callid"].ToString()%>"class="alternar"   >  
                        <td><%=dr["callid"].ToString()%></td>
                        <td><%=dr["maquina"].ToString()%></td>
                        <td><%=dr["subject"].ToString()%></td>
                        <td><%=dr["descrption"].ToString()%></td>
                        <td><textarea readonly  style="width:500px; height:100px" class="form - control"  > <%=dr["notes"].ToString()%></textarea></td>
                        <td><%=dr["name"].ToString()%></td>
                        <td><%=dr["createdate"].ToString()%></td>
                        <td>
                        <input type="button"   class="btn btn-success "  onclick="enviar_resolucion(<%=dr["callid"].ToString()%>,'<%=dr["maquina"].ToString()%>','<%=dr["subject"].ToString()%>','<%=est_detalle%>');"  value="AGREGAR RESOLUCION">
                        </td>

 


                        </tr>   
      <% 

              }
              dr.Close();
          }
          catch (Exception ex)
          {   }


%>     
              
          </table> 
 
        <div id="contenido_div"> </div>
        </form>
 