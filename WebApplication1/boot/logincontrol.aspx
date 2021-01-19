<%@ Page Language="C#"  %>
  <% @Import Namespace="SAPbobsCOM" %>
<% @Import Namespace="System.Data" %>
 
<% @Import Namespace="Libreria" %>
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
                    
                title: "ERROR COMPLETE TODOS LOS CAMPOS" , 
               
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
                    
                title: "ERROR COMPLETE TODOS LOS CAMPOS" , 
               
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

                rs = new SqlCommand(" select a.area, a.nombre,a.perfil, a.cod_usuario as cod_usuario, a.usuario as usuario,a.pass as pass ,b.descripcion as descripcion from ot_usuario a, ot_perfil b  where b.id=a.perfil and a.usuario = '" + usuario_gm + "' and a.pass='"+pass_gm+"'", cnn_gm);
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
                        // Session["pass"] = "1234";

                        String area=dr["area"].ToString();
                        String area_user=dr["area"].ToString();
                        String perfil=dr["perfil"].ToString();
                       
                       if (area_user.Equals("CCHA") ||area_user.Equals("CCH") || area_user.Equals("CCHB") || area_user.Equals("OVO")|| area_user.Equals("LABORATORIO")|| area_user.Equals("gca"))
                        {
                            Session["usuario"] = "ccha";
                        }
                        else if (area_user.Equals("PPR-A") || area_user.Equals("PPR-B")|| area_user.Equals("PPR")|| area_user.Equals("AVI-T"))
                        {
                            Session["usuario"] = "ppr";
                        }
                        else if (area_user.Equals("FCART") ||area_user.Equals("LOG")||area_user.Equals("FERT") ||area_user.Equals("FBFC") )
                        {
                            Session["usuario"] = "fcar";
                        }
                        else if (area_user.Equals("RC") )
                        {
                            Session["usuario"] = "rc";
                        }
                        else if (area_user.Equals("ADM"))
                        {
                            Session["usuario"] = "adm";
                        }
                         else if (area_user.Equals("TALLER")||area_user.Equals("MANT")||area_user.Equals("AFTLSA") )
                        {
                            Session["usuario"] = "mant";
                        }
                          else if (area_user.Equals("FBAL"))
                        {
                            Session["usuario"] = "fbal";
                        }
                         else if (area_user.Equals("SUSTENTABILIDAD"))
                        {
                            Session["usuario"] = "sust";
                        }
                      




/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                        if (area.Equals("CCHA") || area.Equals("CCHB") || area.Equals("OVO"))
                        {
                            //    Session["usuario"] = "cch";
                            Session["correo"] = "alma.larrea@maehara.com.py";
                        }

                        else if (area.Equals("PPR-A") || area.Equals("PPR-B")|| area.Equals("AVI-T"))
                        {   //Session["correo"] = "hernan.velazquez@yemita.com.py-felix.gaona@yemita.com.py";
                            // Session["usuario"] = "ppr";
                            Session["correo"] = "sandra.mario@maehara.com.py-takeo@maehara.com.py";
                        }

                        else if (area.Equals("FCART")&&perfil.Equals("1")||area.Equals("LOG")||area.Equals("FERT") )
                        {
                            Session["correo"] = "nelson@maehara.com.py";
                        }

                        else if (area.Equals("FERT") )
                        {
                            Session["correo"] = "";
                        }
                        else if (area.Equals("LABORATORIO") )
                        {
                            Session["correo"] = "andrea.valenzuela@maehara.com.py";
                        }

                        else if (area.Equals("RC") )
                        {
                            //Session["usuario"] = "rc";
                            Session["correo"] = "johana.lin@maehara.com.py";
                        }

                        else if (area.Equals("TALLER"))
                        {
                            Session["correo"] = "santiago.vega@maehara.com.py";
                            // Session["usuario"] = "mant";
                            //Session["correo"] = "hernan.velazquez@yemita.com.py";
                        }

                        else if (area.Equals("ADM")&&perfil.Equals("1") )
                        {
                            Session["correo"] = "patricia.benitez@maehara.com.py";
                        }


                        if (perfil.Equals("2"))
                        {
                            Session["correo"] = "arturo@maehara.com.py-santiago.vega@maehara.com.py";
                        }


                    }
                    dr.Close();

                    Response.Redirect("index.aspx");

                }

                else
                {
                    Response.Redirect("login_error.aspx");



                }










            }





             %>
