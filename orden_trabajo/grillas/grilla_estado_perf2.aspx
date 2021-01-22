<%@ Page Language="C#" AutoEventWireup="true"%>
<% @Import Namespace="System" %>
<% @Import Namespace="WebApplication1" %>
<% @Import Namespace="System.Data.SqlClient" %>
<%  SqlCommand rs,rs2;
    SqlDataReader dr,dr2;
    String fecha =Request.Params["fecha"];
    String fecha_fin = Request.Params["fecha_fin"];
    String area = Session["area"].ToString();
    String id_usuario = Session["id_usuario"].ToString();
    String conn = Global.sap_conn;
    SqlConnection cnn = new SqlConnection(conn);
    cnn.Open(); %>
 
<style>
        .alternar:hover{ background-color:#ffcc66;}
    </style>

   <%

       try
       {
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
              //  area_sql = "gm.area in ('FCART','FERT')";
           }
           else {
               area_sql = "gm.area='"+condicion+"'";
           }

               
                     String id_oscs = "";
                     String descripcion_oscs = "";
                     rs2 = new SqlCommand("SELECT * FROM OSCS with(nolock) where statusid not in ('-3') ", cnn);

                     dr2 = rs2.ExecuteReader();
                     while (dr2.Read())
                     {
                         id_oscs=dr2["statusid"].ToString();
                         descripcion_oscs=dr2["descriptio"].ToString();

                
               rs = new SqlCommand(" select " +
               " os.subject,os.callid, os.descrption,     " +
               "gm.area ,maq.resname as maquina ,gms.nombre, convert(varchar,os.createdate,103) as fecha        " +
               "from oscl os with(nolock) inner join scl5 sc with(nolock) on os.callID=sc.SrvcCallId         " +
               "inner join GrupoMaehara.dbo.ot_usuario gm on sc.U_Id_Usuario=gm.cod_usuario       " +
               "inner join scl5 scs  with(nolock) on os.callID=scs.SrvcCallId and scs.line=0 and sc.Line=0      " +
               "inner join GrupoMaehara.dbo.ot_usuario gms on scs.U_Id_Usuario=gms.cod_usuario                  " +
               "inner join oclg oc with(nolock) on oc.ClgCode=sc.ClgID     " +
               "inner join oclg oc1 with(nolock) on oc1.ClgCode=scs.ClgID    			     " +
               "inner join orsc maq with(nolock) on maq.rescode=os.U_recurso            " +
               "where   " +
               ""+area_sql+"" +
               "and os.status="+id_oscs+"  and convert(date,os.createdate) between '"+fecha+"' and '"+fecha_fin+"' " +
               "order by 4", cnn);
           dr = rs.ExecuteReader();
%>

  <div class="panel-group wrap" id="bs-collapse" >
                <div class="panel">
                    <div class="panel-heading">
                        <h4 class="panel-title">
                <a data-toggle="collapse" data-parent="#bs-collapse" href="#<%=id_oscs%>">
              <%=descripcion_oscs%> 
                    </a>
                </h4>
                    </div>
                    <div id="<%=id_oscs%>" class="panel-collapse collapse">
                        <div class="panel-body">
                    <div class="row">
                    <div class="col-md-12">
                <div class="panel panel-primary">
         
                    
 
        <table   data-row-style="rowStyle" data-toggle="table" data-click-to-select="true"  id="tabla_informe<%=id_oscs%>" class="table table-striped table-bordered" >
              <thead>
            <tr>   
                <th>NRO.</th>
                <th>MAQUINA</th>
                <th>DESCRIPCIÓN</th>
                <th>DETALLE</th>
                <th>AREA</th>
                <th>FECHA</th>
                <th>CREADO POR</th>
            </tr>
              </thead>
             
        <%
            while (dr.Read())  {
               String id= dr["callid"].ToString();
               String descripcion= dr["subject"].ToString();
               String FECHA= dr["fecha"].ToString();
               String obss= dr["descrption"].ToString();
               String MAQUINA= dr["maquina"].ToString();
               String nombre= dr["nombre"].ToString();
               String lugar= dr["area"].ToString();
                  %>
                  
            <tr id="<%=id%>">  
                <td><%=id%></td>
                <td><%=MAQUINA%></td>
                <td><%=descripcion%></td>
                <td><%=obss%></td>
                <td><%=lugar%></td>
                <td><%=FECHA%></td> 
                <td><%=dr["nombre"].ToString()%></td>   
            </tr>   
                     
                   
                  <%}dr.Close(); %>
        </table>
               <script>
                   cargar_estilo_grilla('tabla_informe<%=id_oscs%>')
</script>                     
                </div> 
                                            
                    </div>
                                            
                    </div>     
                                    
                        </div>
                    </div>
             </div>
       </div>
 

     <%

             }
             dr2.Close();

         }
         catch (Exception ex)
         {   }


            
cnn.Close();
   %>
