<%@ Page Language="C#" AutoEventWireup="true"   %>

<!DOCTYPE html>
 <%       if (Session["nombre_usuario"] == null)
    {
         Response.Redirect("login.aspx");
       
    }  %>
 
     
 <%

String nombre_usuario = Session["nombre_usuario"].ToString();
               %>
        <div class="container-fluid">
    <form id="frm_agregar" name="frm_agregar"method="POST">
                <span class="input-group-addon">USUARIO</span> 
                <input type="text" class="form-control" name="usuario" id="usuario" value="<%=nombre_usuario%>"" readonly="readonly" required="true">
                <br><br>
        <div class="input-append">  
                <input name="txt_pass" id="txt_pass" type="password"  placeholder="INGRESE NUEVA CONTRASEÑA"required class="form-control">
                </div>   
                <br><br>
                <input type="button" value="CAMBIAR" id="btn_registrar" name="btn_registrar" class="form-control btn btn-primary " onclick="registrar($('#txt_pass').val());" style="  height:70px"/>
    </form>
         </div>
                  
            <script>
                
                function registrar(pass)  {

                    $.get('control_cambio_pass.aspx', { pass:pass},
                function(res){
                    
                    $("#contenido").html(res);

                });
                }

            </script>
         
        
        
        
      

