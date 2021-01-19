<%@ Page Language="C#" AutoEventWireup="true" %>

 <% @Import Namespace="System" %>
<% @Import Namespace="WebApplication1.boot" %>
<% @Import Namespace="System.Data.SqlClient" %>

<% //DataSet ds;
        SqlCommand rs;
        SqlDataReader dr;
        if (Session["nombre_usuario"] == null)
        {
            Response.Redirect("login.aspx");
        }
        String usuario = Request.Params["txt_usuario"];
        String id_usuario =Session["id_usuario"].ToString();
        String area = Session["area"].ToString();;
        String conn = Global.conn;
        SqlConnection cnn = new SqlConnection(conn);
        cnn.Open();

   
     %>
 

<style>
     .alternar:hover{ background-color:#ffcc66;}
    </style>

<form id="grilla_ot" method="post">
  <table  id="tabla_informe" class="table table-striped table-bordered"   data-row-style="rowStyle" data-toggle="table" data-click-to-select="true">
             <thead> 
             <tr style="background-color:rgba(255, 14, 14, 0.57);" >
                <th>NRO.</th>
                 <th>DESCRIPCIÓN</th>
                 <th>DETALLE</th>
                 <th>RESOLUCIÓN</th>
                 <th>NOTAS</th>
                 <th>FECHA DE CREACION</th>
                 <th>ACCIÓN</th>
                <th>ACCIÓN</th>
             </tr> 

                 </thead>
            <%

                try
                {


                    //status -2 = a pendiente 
                    rs = new SqlCommand(" select  os.descrption, os.status, os.subject, os.callid, t4.nombre, sc.U_Id_Usuario,os.resolution ,convert(varchar,os.createdate,103) as createdate,oc2.notes	  " +
                        "from oscl os with(nolock) inner join scl5 sc with(nolock) on os.callID=sc.SrvcCallId    " +
                        "inner join osco c with(nolock) on c.originID=os.origin   " +
                        "inner join oclg oc with(nolock) on oc.ClgCode=sc.ClgID  " +
                        "inner join scl5 sc2 on os.callID=sc2.SrvcCallId    inner join oclg oc2  with(nolock) on oc2.ClgCode=sc2.ClgID and oc2.closed='N' " +
                        "inner join grupomaehara.dbo.ot_usuario t4 on  sc.U_Id_Usuario=t4.cod_usuario  " +
                        "where     os.status='5'  " +
                        "and sc.Line='0'  " +
                        "and sc.U_Id_Usuario='"+id_usuario+"'", cnn);

                    dr = rs.ExecuteReader();
                    while (dr.Read())
                    {
                        


               %>
                        <tr id="<%=dr["callid"].ToString()%>"class="alternar"   >  
                        <td><%=dr["callid"].ToString()%></td>
                        <td><%=dr["subject"].ToString()%></td>
                        <td><%=dr["descrption"].ToString()%></td>
                        <td><%=dr["resolution"].ToString()%></td> 
                        <td><textarea  readonly style="width:500px; height:100px" class="form - control"  > <%=dr["notes"].ToString()%></textarea></td>
                        <td><%=dr["createdate"].ToString()%></td> 
                            
                            <td>
 
                              <input type="button"   class="btn btn-success "  onclick=" aprobar_verificacion( <%=dr["callid"].ToString()%>); "  value="APROBAR VERIFICACION">
                                </td>

                            <td>
 
                              <input type="button"   class="btn btn-warning "  onclick=" cerrar_registro_verificacion(<%=dr["callid"].ToString()%>);   "  value="RECHAZAR">
                                </td>

 


                        </tr>   
      <% 

                        }
                        dr.Close();
                    }
                    catch (Exception ex)
                    {   } 
        
 
%>        </table> 
   

    <div id="contenido_div"> </div>
 </form>






 