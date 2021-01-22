<%@ Page Language="C#" AutoEventWireup="true"   %>
<% @Import Namespace="System.Data.SqlClient" %> 
<% @Import Namespace="WebApplication1" %>
<!DOCTYPE html>
<%
     if (Session["nombre_usuario"] == null)
    {
        Response.Redirect("login.aspx");

    }
    String con_gmaehara = Global.gm_conn;
    SqlConnection conex_gmehara = new SqlConnection(con_gmaehara);
    String pass=Request.Params["pass"];
    String usuario = Session["nombre_usuario"].ToString();
    String perfil = Session["perfil"].ToString();


    string sql = "update ot_usuario set pass='"+pass+"' where usuario='"+usuario.Trim()+"'";

    //Cria uma objeto do tipo comando passando como parametro a string sql e a string de conexão
    SqlCommand comando = new SqlCommand(sql, conex_gmehara);
    conex_gmehara.Open();
    //executa o comando com os parametros que foram adicionados acima

    comando.ExecuteNonQuery();
    //fecha a conexao
    conex_gmehara.Close();
     %>

<script>
    
                swal({
                    
                title: "CONTRASEÑA CAMBIADA" , 
               
                confirmButtonText: "CERRAR" 



    });

    var perfil = '<%=perfil.Trim()%>';
    if (perfil == "1") {
        
            traer_menu();
              
    }

    else if (perfil == "2") {

        
            traer_menu_admin();
      
    }

    else if (perfil == "3") {

        
            traer_menu_mant();
        
    }


    else if (perfil == "4") {

        
            traer_menu_encargado_mantenimiento();
      
    }
    </script>   
