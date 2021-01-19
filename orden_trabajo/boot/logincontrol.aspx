<%@ Page Language="C#"  %>
  <% @Import Namespace="SAPbobsCOM" %>
<% @Import Namespace="System.Data" %>
 
<% @Import Namespace="WebApplication1.boot" %>
<% @Import Namespace="System.Data.SqlClient" %>
 
 

<%  
    SqlDataAdapter sql;
     DataSet ds;
    SqlCommand rs;
    SqlDataReader dr;
    //String usuario = Request.Params["txt_usuario"];
    //String pass= Request.Params["txt_pass"];

    String usuario_gm = Request.Params["txt_usuario"];
    String pass_gm=Request.Params["txt_pass"];
    String perfil_gm;

    String nombre_usuario = "";
    String id_usuario = "";

    String con_gm = Global.gm_conn;

    SqlConnection cnn_gm = new SqlConnection(con_gm);
     
         cnn_gm.Open();


    if ( string.IsNullOrEmpty(usuario_gm))
    {

      %>   <script>


               swal({

                   title: "ERROR COMPLETE TODOS LOS CAMPOS",

                   confirmButtonText: "CERRAR"
               });

   //$.preloader.stop();
                    </script>       
        <%    
      
    }
    if (string.IsNullOrEmpty(pass_gm))
    {
 %>   <script>


          swal({

              title: "ERROR COMPLETE TODOS LOS CAMPOS",

              confirmButtonText: "CERRAR"
          });

  // $.preloader.stop();
                    </script>       
        <%    



            }
            else

            {


                String query=" select * from ot_usuario  where  usuario = '" + usuario_gm + "' and pass='"+pass_gm+"'";

                SqlDataAdapter sda = new SqlDataAdapter(query, cnn_gm);

                DataTable dtb1 = new DataTable();

                rs = new SqlCommand("select a.area, a.nombre,a.perfil, a.cod_usuario as cod_usuario," +
                    " a.usuario as usuario,a.pass as pass ,b.descripcion as descripcion ,a.usuario_sap," +
                    "  isnull(d.correo,'reportes.vmiis@gmail.com') as correo_envio from ot_usuario a  " +
                        "inner join    ot_perfil b on b.id=a.perfil	" +
                        "left outer join   ot_correo_det c on a.perfil=c.perfil and a.area=c.area left outer join   " +
                        "ot_correos d on c.id_cab=d.id where b.id=a.perfil and a.usuario = '" + usuario_gm + "' and a.pass='"+pass_gm+"'", cnn_gm);
                sda.Fill(dtb1);
                if (dtb1.Rows.Count == 1)
                {
                    dr = rs.ExecuteReader();
                    while (dr.Read())
                    {



                        Session["id_usuario"] = dr["cod_usuario"].ToString();
                        Session["nombre_usuario"] = dr["usuario"].ToString();
                        Session["perfil_grupomaehara"] = dr["descripcion"].ToString();
                        Session["perfil"] = dr["perfil"].ToString();
                        Session["nombre_usuario_gm"] = dr["nombre"].ToString();
                        Session["area"] = dr["area"].ToString();
                        Session["user_name"] = usuario_gm;
                        //Session["usuario"] = "ccha";
                        Session["pass"] = "1234";
                        Session["usuario"] = dr["usuario_sap"].ToString();
                        // Session["pass"] = "1234";
                        Session["correo"] =dr["correo_envio"].ToString();
                        String area=dr["area"].ToString();
                        String area_user=dr["area"].ToString();
                        String perfil=dr["perfil"].ToString();

                    }
                    dr.Close();

                    Response.Redirect("index.aspx");

                }

                else
                {
                    Response.Redirect("login_error.aspx");

                }

            }

            cnn_gm.Close();

              %>
