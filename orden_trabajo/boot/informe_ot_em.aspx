<%@ Page Language="C#" AutoEventWireup="true"   %>

 <% @Import Namespace="System" %>
<% @Import Namespace="WebApplication1.boot" %>
<% @Import Namespace="System.Data.SqlClient" %>

<%  

           if (Session["nombre_usuario"] == null)
    {
         Response.Redirect("login.aspx");
       
    } 
    SqlCommand rs,rs2,rs3;
    SqlDataReader dr,dr2,dr3;
    String usuario = Request.Params["txt_usuario"];
    String id_usuario =Session["id_usuario"].ToString();
    String area = Session["area"].ToString();
    String conn = Global.conn;
    SqlConnection cnn = new SqlConnection(conn);
    cnn.Open();
    
     String area_informe = "";
     if (area.Trim().Equals("CCH"))
    {
        area_informe = "in ('ccha','cchb','ovo','cchh')";
     }
    else if  (area.Equals("FBFC"))
    {
        area_informe = "in ('FBAL','FCART')";
      }
    else
    {
         area_informe="='"+area+"'";
    }
     %>
  
     

<form id="grilla_ot" method="post">
    
  <table  id="tabla_informe" class="table table-striped table-bordered"  >
                                   <thead>

             <tr style="background-color:rgba(255, 14, 14, 0.57);" >
         
                     <th>NRO.</th>
                 <th>MAQUINA</th>
                 <th>DESCRIPCIÓN</th>
                 <th>DETALLE</th>
                 <th>NOTA</th>
                 <th>AREA</th>
                 <th>FECHA DE CREACION</th>
                 <th>ASIGNAR OPERARIOS</th>
                 
            </tr> 
                                       </thead>
      <tbody id="tbody_id"> 
            <%

                try
                {
                    //status -2 = a pendiente 
                    rs = new SqlCommand("select t1.u_usuario ,t0.descrption,t0.subject,t0.callid,  " +
                        "t3.Name ,maq.resname as maquina,convert(varchar,t0.createdate,103) as createdate , oc.notes " +
                        "from oscl t0 with(nolock) inner join scl5 t1 with(nolock) on t0.callid=t1.SrvcCallId " +
                        "inner join oclg t2 with(nolock) on t1.ClgID=t2.ClgCode " +
                        "inner join osco t3 with(nolock) on t0.origin=t3.originid " +
                        "inner join orsc maq with(nolock) on maq.rescode=t0.U_recurso  " +
                        "inner join scl5 sc2 on t0.callID=sc2.SrvcCallId    " +
                        "inner join oclg oc  with(nolock) on oc.ClgCode=sc2.ClgID   and oc.closed='N'" +
                        "where  t0.status=3   " +
                        "and t2.U_Id_Asignado='"+id_usuario.Trim()+"'", cnn);


                    dr = rs.ExecuteReader();
                    while (dr.Read())
                    {
                      
                     %>
                        <tr id="<%=dr["callid"].ToString()%>"class="alternar"   >  
                        <td><%=dr["callid"].ToString()%></td>
                        <td><%=dr["maquina"].ToString()%></td>
                        <td><%=dr["subject"].ToString()%></td>
                        <td><%=dr["descrption"].ToString()%></td>
                        <td><textarea  readonly style="width:500px; height:80px" class="form - control"  > <%=dr["notes"].ToString()%></textarea></td>
                        <td><%=dr["name"].ToString()%></td>
                        <td><%=dr["createdate"].ToString()%></td>

                            
                            <td>
 
                              <input type="button" data-toggle="modal" data-target="#4" data-dismiss="modal"   class="btn btn-success "  onclick="$('#id_orden').val(<%=dr["callid"].ToString()%>);"  value="ASIGNAR">
                                </td>

 


                        </tr>   
      <% 

              }
              dr.Close();
          }
          catch (Exception ex)
          {   }


%>      

  
    
    </tbody>
    
              
          </table> 
    


    
    <div id="contenido_div"> </div>
 </form>

                 
          

    <div class="modal fade" id="4" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
     <form id="form_editar"> 
     
     <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-header">
          
            <a>ASIGNACION DE OPERARIOS</a>
         </div>
           <div class="modal-body">
                    <select  name="cbox_operario"   id="cbox_operario"  multiple="multiple" style="width:300px; height:80px"    >
                      <%
        rs2 = new SqlCommand("select distinct  b.empid as id_empleado,(c.firstName +' '+c.lastName )as nombre  from ohtm a with(nolock) inner join   " +
                                "htm1 b with(nolock) on a.teamID=b.teamID  " +
                                "inner join ohem c with(nolock) on b.empID=c.empID where  b.role='m'    and c.Active='Y' and b.empid not in('"+id_usuario+"') order by 2", cnn);
       dr2 = rs2.ExecuteReader();
       while (dr2.Read())
       {
           String id_op= dr2["id_empleado"].ToString();
           String nombre= dr2["nombre"].ToString();
            %> 
                    <option value="<%=id_op%>"><%=nombre%></option>
             <%} dr2.Close(); %>

                    </select>
             <input type="hidden" id="id_orden" name="id_orden"  >
               <br><br>

 <textarea style="text-transform: uppercase;width:400px; height:80px"  name = "nota" id="nota" class="form-control" placeholder="AGREGAR NOTA"></textarea>
                           
 <br> <br>
          </div>
            <input class="btn btn-primary  example2 " id="id_registro" type="button" value="REGISTRAR"  onclick="validar_asignacion();" data-dismiss="modal"  > <br />
                   <button  class ="btn btn-danger" type="button" data-dismiss="modal">VOLVER</button>
      </div>
    </div>
         </form>
  </div>
                 