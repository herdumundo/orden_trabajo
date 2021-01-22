<%@ Page Language="C#" AutoEventWireup="true" %>

<!DOCTYPE html>

<form method="post" id="form_ot">
<% @Import Namespace="System" %>
<% @Import Namespace="WebApplication1" %>
<% @Import Namespace="System.Data.SqlClient" %>
<% 
    if (Session["nombre_usuario"] == null)
    {
        Response.Redirect("login.aspx");

    }
    String conn = Global.conn;
    SqlConnection cnn  = new SqlConnection(conn);

    String conn_GM = Global.gm_conn;
    SqlConnection cnn_GM = new SqlConnection(conn_GM);
    cnn.Open();
    cnn_GM.Open();
    String perfil = Session["perfil"].ToString();
    String area=Session["area"].ToString();
    String id_usuario=Session["id_usuario"].ToString();
    SqlCommand rs,rs1;
    SqlDataReader dr,dr1;
%>
  <input type="checkbox"  data-toggle="toggle" data-on="LOGISTICA" data-off="MANTENIMIENTO" id="chkToggle2" data-onstyle="success" data-offstyle="warning">
    
    <input style="display:none" type="text" value="P44444401" id="condicion_ot" name="condicion_ot"/>
    <br><br>

                             
      <div class="form-groupss" style="display:none" id="div_fecha_log" >
         

         <label class="form-control-placeholder"><b>Fecha necesaria</b></label>
         
 <input  style=" font-weight: bold"class="datepicker"  type="text" id="fecha_log" name="fecha_log">     
      </div>   
     <div class="form-groupss " >
         

         <label class="form-control-placeholder"><b>Descripcion</b></label>
         
         <input name="txt_problema" style="text-transform: uppercase;" autocomplete="off" id="txt_problema" required  type="text" class="form-control" "placeholder="PROBLEMA">
 
      </div>        
       <br>

    <div class="form-groupss " >
         
         <label class="form-control-placeholder"><b>DETALLE DEL PROBLEMA</b></label>
         
        <textarea style="text-transform: uppercase;"  name = "description" id="description" required class="form-control"></textarea>
 
      </div>  
         
         <br>
      

      <div class="form-groupss " >
        <label class="form-control-placeholder"><b>Origen</b></label>
            <select class="form-control" name="cbox_origen" id="cbox_origen" onchange="buscar_maquina_area();" >
                <OPTION value=""    >Origen</OPTION>
                   <%  
                        rs = new SqlCommand("exec [mae_ot_areas_registro_pedido] @area_perfil='"+area.Trim() +"',@id_usuario="+id_usuario+" ", cnn_GM);
                         dr = rs.ExecuteReader();
                         while (dr.Read())
                         {  %> 
                    <OPTION VALUE="<%=dr["originID"].ToString()%>"><%=dr["descriptio"].ToString()%></OPTION>   <% } dr.Close();%>
            </select> 
    </div>  
    <br>
     <div  id= "div_proveedor" >
    <div class="form-groupss " >
        <label class="form-control-placeholder"><b>Maquina</b></label>
             <select class="form-control" name="cbox_maquina" id="cbox_maquina" onclick="filtrar_sub_categoria();" onchange="$('#txt_bolean_maquina').val('A');">

            </select>
    </div>  
   <br> 
         
    <div id="sub_categoria">
         <select id="id_categoria" name="id_categoria"  class="form-control">

         </select>

    </div>
             <br>
    <div class="form-groupss " >
         
        <label class="form-control-placeholder"><b>TIPO DE PROBLEMA</b></label>
        <select class="form-control" name="cbox_tipo_problem" id="cbox_tipo_problem">
            <OPTION value=""    >TIPO DE PROBLEMA</OPTION>
     <%     rs1 = new SqlCommand(" select * from oscp with(nolock) ", cnn);
            dr1 = rs1.ExecuteReader();
            while (dr1.Read())
            { %> 
            <OPTION VALUE="<%=dr1["prblmTypID"].ToString()%>"><%=dr1["Descriptio"].ToString()%></OPTION>
            <% } dr1.Close();%>
        </select> 
    </div>  

   </div>  
     <br>  

    <input type="submit" value="Registrar" id="btn_registrar" name="btn_registrar" class="form-control btn btn-info "   onclick="validar_envio(<%=perfil%>);" />
 
    <br>  
    </form>

  