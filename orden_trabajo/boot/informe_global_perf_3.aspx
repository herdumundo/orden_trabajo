<%@ Page Language="C#" AutoEventWireup="true"%>
<% @Import Namespace="System" %>
<% @Import Namespace="WebApplication1.boot" %>
<% @Import Namespace="System.Data.SqlClient" %>
<%
    if (Session["nombre_usuario"] == null)
    {
        Response.Redirect("login.aspx");
    }
    SqlCommand rs;
    SqlDataReader dr;
    String area = Session["area"].ToString();
    String usuario = Request.Params["txt_usuario"];
    String id_usuario = Session["id_usuario"].ToString();
    String conn = Global.conn;
    SqlConnection cnn = new SqlConnection(conn);
    cnn.Open();
    String condicion = area;
    String area_sql = "";

    if (id_usuario.Equals("29"))
    {
        area_sql = "gm.area in ( 'LOG')";

    }

    else
    {
        area_sql = "gm.area in ('ccha','cchb','ovo','PPR-A','PPR-B','AVI-T','SANI','AVI-T','FER','TALLER','LOG','SUSTENTABILIDAD','ADM','FBAL','FCART','LOG','FCART','FERT')";


    }
    rs = new SqlCommand("select " +
               " os.subject,os.callid, os.descrption,     " +
               "gm.area ,maq.resname as maquina ,gms.nombre, convert(varchar,os.createdate,103) as fecha ,oc2.notes       " +
               "from oscl os with(nolock) inner join scl5 sc with(nolock) on os.callID=sc.SrvcCallId         " +
               "inner join GrupoMaehara.dbo.ot_usuario gm on sc.U_Id_Usuario=gm.cod_usuario       " +
               "inner join scl5 scs  with(nolock) on os.callID=scs.SrvcCallId and scs.line=0 and sc.Line=0      " +
               "inner join GrupoMaehara.dbo.ot_usuario gms on scs.U_Id_Usuario=gms.cod_usuario                  " +
               "inner join oclg oc with(nolock) on oc.ClgCode=sc.ClgID     " +
               "inner join oclg oc1 with(nolock) on oc1.ClgCode=scs.ClgID    			     " +
               "inner join orsc maq with(nolock) on maq.rescode=os.U_recurso    " +
               " inner join scl5 sc2 on os.callID=sc2.SrvcCallId    " +
               "inner join oclg oc2  with(nolock) on oc2.ClgCode=sc2.ClgID  and oc2.closed='N'       " +
               "where   " +
               ""+area_sql+"" +
               "and os.status in (1,2,3,4,5)    " +
               "order by 2 desc  ", cnn);

    dr = rs.ExecuteReader();
    %>
        <table   data-row-style="rowStyle" data-toggle="table" data-click-to-select="true"  id="tabla_global_inf_3" class="table table-striped table-bordered" >
              <thead>
            <tr>   
                      <th>NRO.</th>
            <th>MAQUINA</th>
            <th>DESCRIPCIÓN</th>
            <th>DETALLE</th>
            <th>AREA</th>            
            <th>NOTAS</th>
            <th>FECHA</th>
            <th>CREADO POR</th>

            </tr>
              </thead>
     
        <%
            
             while (dr.Read())
                      {
                                  %>
                  
                      <tr id="<%=dr["callid"].ToString()%>">  
                         <td><%=dr["callid"].ToString()%></td>
                        <td><%=dr["maquina"].ToString()%></td>
                        <td><%=dr["subject"].ToString()%></td>
                        <td><%=dr["descrption"].ToString()%></td>
                        <td><%= dr["area"].ToString()%></td>
                        <td><textarea readonly style="width:500px; height:80px" class="form - control"  > <%=dr["notes"].ToString()%></textarea></td>   
                        <td><%=dr["fecha"].ToString()%></td> 

                       <td><%=dr["nombre"].ToString()%></td>   
                     
                        </tr>   
                     
                   
                  <%}dr.Close(); %>
        </table>
 


<%cnn.Close();%>