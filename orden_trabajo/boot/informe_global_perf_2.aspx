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
     if (condicion.Trim().Equals("CCH"))
           {
               area_sql = "gm.area in ('ccha','cchb','ovo')";
           }
           else if (condicion.Trim().Equals("PPR"))
           {
               area_sql = "gm.area in ('PPR-A','PPR-B','AVI-T','SANI')";
           }
           else if (condicion.Trim().Equals("AFTLSA"))
           {
               area_sql = "gm.area in ('AVI-T','FER','TALLER','LOG','SUSTENTABILIDAD','ADM')";
           }
           else if (condicion.Trim().Equals("FBFC"))
           {
               area_sql = "gm.area in ('FBAL','FCART')";
           }
           else if (condicion.Trim().Equals("FCART"))
           {
              area_sql = "gm.area in ('LOG','FCART','FERT')";
           }
           else {
               area_sql = "gm.area='"+condicion+"'";
           }

    rs = new SqlCommand(" select  os.subject,os.callid, os.descrption,     "+
    "   gm.area ,maq.resname as maquina ,gms.nombre, convert(varchar,os.createdate,103) as fecha  ,os.status  ,oscs.Descriptio as nombre_estado ,oc1.notes "+  
    "   from oscl os with(nolock) inner join scl5 sc with(nolock) on os.callID=sc.SrvcCallId         "+
    "   inner join GrupoMaehara.dbo.ot_usuario gm on sc.U_Id_Usuario=gm.cod_usuario       "+
    "   inner join scl5 scs  with(nolock) on os.callID=scs.SrvcCallId and scs.line=0 and sc.Line=0     "+ 
    "   inner join GrupoMaehara.dbo.ot_usuario gms on scs.U_Id_Usuario=gms.cod_usuario           "+       
    "   inner join oclg oc with(nolock) on oc.ClgCode=sc.ClgID     "+
    "    inner join scl5 sc2 on os.callID=sc2.SrvcCallId inner join oclg oc1 with(nolock) on oc1.ClgCode=sc2.ClgID    and oc1.closed='N'   			     "+
    "   inner join orsc maq with(nolock) on maq.rescode=os.U_recurso    "+
    "   inner join oscs on os.status=oscs.statusID        "+
    "   where   os.status in (1,2,3,4,5) and "+area_sql+" ", cnn); 
           
    dr = rs.ExecuteReader();
    %>
        <table   data-row-style="rowStyle" data-toggle="table" data-click-to-select="true"  id="tabla_global_inf_2" class="table table-striped table-bordered" >
              <thead>
            <tr>   
                <th>NRO.</th>
                <th>MAQUINA</th>
                <th>DESCRIPCIÓN</th>
                <th>DETALLE</th>
                <th>AREA</th>
                <th>FECHA</th>
                <th>CREADO POR</th>
                <th>NOTAS</th>
                <th>ESTADO</th>
            </tr>
              </thead>
     
        <%
            while (dr.Read())  {
               
                  %>
                  
            <tr id="<%=dr["callid"].ToString()%>">  
                <td><%=dr["callid"].ToString()%></td>
                <td><%=dr["maquina"].ToString()%></td>
                <td><%=dr["subject"].ToString()%></td>
                <td><%=dr["descrption"].ToString()%></td>
                <td><%= dr["area"].ToString()%></td>
                <td><%=dr["fecha"].ToString()%></td> 
                <td><%=dr["nombre"].ToString()%></td>   
                <td><textarea readonly style="width:500px; height:80px" class="form - control"  > <%=dr["notes"].ToString()%></textarea></td>   
                <td><%=dr["nombre_estado"].ToString()%></td>   
            </tr>   
                     
                   
                  <%}dr.Close(); %>
        </table>
 


<%cnn.Close();%>