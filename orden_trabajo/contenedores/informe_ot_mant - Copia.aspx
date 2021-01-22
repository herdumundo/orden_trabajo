 <%@ Page Language="C#" AutoEventWireup="true"   %>

 <% @Import Namespace="System" %>
<% @Import Namespace="WebApplication1" %>
<% @Import Namespace="System.Data.SqlClient" %>

<% //DataSet ds;
    SqlCommand rs,rs3,rs4;
     SqlDataReader dr,dr3,dr4;
    String usuario = Request.Params["txt_usuario"];
    String id_usuario =Session["id_usuario"].ToString();
    String area = Session["area"].ToString();
    String conn = Global.conn;
    SqlConnection cnn = new SqlConnection(conn);
    String customer=  Request.Params["customer"];
    cnn.Open();
    String area_formato = "";
    String estado_formateado = "";
    
    %>

 

<script>
              
            function modal_animacion(i){
                swal({
                    
                title: "DETALLE DE ORDEN NRO."+i, 
                html: "<div id='div_grilla'></div>",  
                confirmButtonText: "CERRAR" 
                        });
                                        } 
        </script> 


<style>
     .alternar:hover{ background-color:#ffcc66;}
    </style>

<form id="grilla_ot" method="post">
  <table  id="tabla_informe" class="table table-striped table-bordered"   data-row-style="rowStyle" data-toggle="table" data-click-to-select="true">
              <thead>
             <tr style="background-color:rgba(255, 14, 14, 0.57);" >
         
 
                    <th>NRO.</th>
                    <th>CREADO POR.</th>
                 <th>MAQUINA</th>
                 <th>DESCRIPCIÓN</th>
                 <th>DETALLE</th>
                 <th>AREA</th>
                 <th>TIPO DE PROBLEMA</th>
                 <th>FECHA DE CREACION</th>   
                 <th>NOTA</th>
                 <th>RECHAZAR</th>
                 <th>APROBAR</th>
            </tr> 
                  </thead>
            <%
                try
                {


                    rs = new SqlCommand("exec select_informe_ot_perf3 @area='"+area+"',@customer='"+customer+"' ", cnn);



                    dr = rs.ExecuteReader();
                    while (dr.Read())
                    {
                        String id= dr["callid"].ToString();
                        String descripcion= dr["subject"].ToString();
                        String estado= dr["descrption"].ToString();
                        String est=Regex.Replace(estado, @"\r\n?|\n", "-");
                        String area_usuario= dr["name"].ToString();
                        String MAQUINA= dr["maquina"].ToString();
                        String area_usuario_res = "";

                        if (area_usuario.Equals("CCHA")||area_usuario.Equals("CCHB")||area_usuario.Equals("OVO")||area_usuario.Equals("CCHH"))
                        {
                            area_usuario_res = "CCH";
                        }
                        else if (area_usuario.Equals("FBAL"))
                        {
                            area_usuario_res = "FBFC";
                        }
                        else if (area_usuario.Equals("PPR-B"))
                        {
                            area_usuario_res = "PPR-B";
                        }
                        else if (area_usuario.Equals("PPR-A"))
                        {
                            area_usuario_res = "PPR-A";
                        }

                        else if (area_usuario.Equals("AVI-T")||area_usuario.Equals("TALLER")||area_usuario.Equals("ADM")||area_usuario.Equals("FERT")||area_usuario.Equals("LOG")||area_usuario.Equals("SUSTENTABILIDAD"))
                        //
                        {
                            area_usuario_res = "AFTLSA";
                        }
                        else
                        {
                            area_usuario_res = area_usuario;
                        }
             %>
                        <tr id="<%=id%>"class="alternar"   >  
                        <td><%=id%></td>
                        <td><%=dr["u_usuario"].ToString()%></td>

                        <td><%=MAQUINA%></td>
                        <td><%=descripcion%></td>
                        <td><%=estado%></td>
                        <td><%=area_usuario%></td>
                        <td><%=dr["tipo_problema"].ToString()%></td>
                        <td><%=dr["createdate"].ToString()%></td>
                        <td><textarea readonly  style="width:500px; height:100px" class="form - control"  > <%=dr["notes"].ToString()%></textarea></td>
                        <td>
                              <input type="button" data-toggle="modal" data-target="#4" data-dismiss="modal"   class="btn btn-warning "  onclick="$('#id_orden').val(<%=id%>);"  value="CERRAR ORDEN">
                              </td>
                              <td>
  <input type="button" data-toggle="modal" data-target="#5" data-dismiss="modal"   class="btn btn-success " 
      onclick="$('#id_orden').val(<%=id%>);$('#detalle').val('<%=est%>');$('#descripcion').val('<%=descripcion%>'); validar_formato_area_mant('<%=area_usuario_res%>');"  value="APROBAR">
 
 
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
     
    <input type="text" id="id_orden" name="id_orden" style="display:none"  >
    <input type="text" id="descripcion" name="descripcion"  style="display:none"  >
    <input type="text" id="detalle" name="detalle" style="display:none">
    
    
    <div id="contenido_div"> </div>
 </form>

    <form id="frm_agregar4"    method="POST">
                 
        <div class="modal fade" id="4" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                    <input type="text" id="txt_comentario" name="txt_comentario" placeholder="INGRESAR MOTIVO" class="form-control">
                    <h5 class="modal-title" id="exampleModalLabel"></h5>
                    </div>
                        <div class="form-inline text-center">
                        <br><br><br><br><br>
                            <input style="width:500px; height:80px" class="btn btn-primary" data-dismiss="modal" type="button" value="CERRAR ORDEN"  onclick="anular_registro_mant($('#id_orden').val(),$('#txt_comentario').val());"  > 
                            <br>
                            <button style="width:500px; height:80px" class="btn btn-danger" type="button" data-dismiss="modal">VOLVER</button>
                        </div>
                </div>
            </div>   
        </div>              
    </form>

    <form id="frm_agregar5"    method="POST">
        <div class="modal fade" id="5" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <div id="combo" class="form-group">                 
                          
                            <a>TERCERIZADOS</a>
                            <input type="checkbox"   data-toggle="toggle" data-on="SI"    data-off="NO" id="chkToggle2" data-onstyle="success"    data-offstyle="warning">
                        </div>
                    </div>
                        <div class="form-inline text-center">
                
                     <input type="text" id="id_orden_terc" name="id_orden_terc" style="display:none" >
                    <select style="display:none ;width:500px; height:80px" name="cbox_proveedor"   id="cbox_proveedor" class="form-control"  multiple="multiple">
                        
                    <%  rs3 = new SqlCommand("select * from ocrd where U_rubro_prov is not null", cnn);
                        dr3 = rs3.ExecuteReader();
                        while (dr3.Read())
                    {
                       
                     %> 
                    <option value="<%=dr3["cardcode"].ToString()%>"><%=dr3["cardname"].ToString()%></option>
                     <%} dr3.Close();  %> 
                    </select>
                    <br>
                       
                <div  >        
                <br><br>
                <a>ENCARGADO DE MANTENIMIENTO</a> <br>
                 <select name="cbox_encargado_mant"   id="cbox_encargado_mant" class="form-control">
                                        <%
                       rs4 = new SqlCommand(" select distinct  b.empid as id_empleado,(c.firstName +' '+c.lastName )as nombre, z.area  from ohtm a inner join  htm1 b on a.teamID=b.teamID inner join ohem c on b.empID=c.empID inner join grupomaehara.dbo.ot_usuario z on z.cod_usuario=b.empID  where c.Active='Y' and  b.role='L'  and b.empid not in (40) order by 2", cnn);
                       dr4 = rs4.ExecuteReader();
                       while (dr4.Read())
                       {  %> 
                 <option id="<%=dr4["area"].ToString()%>" value="<%=dr4["id_empleado"].ToString()%>"><%=dr4["nombre"].ToString()%></option>
                   <%} dr4.Close(); %> 
                    </select>

                   
                </div>  <br>
                            <div>
<br><br>

 <textarea style="text-transform: uppercase;width:500px; height:80px"  name = "nota" id="nota" class="form-control" placeholder="AGREGAR NOTA"></textarea>
                           
 <br> <br>
                            </div>
                             <br> <br>
                           
                                  <div>
                                <input style="width:500px; height:80px" class="btn btn-primary  example2 " id="id_registro" type="button" value="APROBAR"  onclick="aprobar_registro_mant($('#id_orden').val()); " data-dismiss="modal"  > 
                                    <br>
                                  <button style="width:500px; height:80px" class="btn btn-danger" type="button" data-dismiss="modal">VOLVER</button>
                               </div>
                      
                  </div>
                </div></div> <div id="id_s"></div>  </div>             
                  </form>





 