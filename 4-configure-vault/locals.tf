locals {
  boundary_user_data_json = {
    policies = [ "boundary" ]
    password = "boundary123"
  }
  vnc_password = {
    password = "idbehold"
  }
}