# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     GeoTasksDb.Repo.insert!(%GeoTasksDb.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

GeoTasksDb.create_new_role(%{name: "Manager"})
GeoTasksDb.create_new_role(%{name: "Driver"})

{:ok, m1} = GeoTasksDb.create_new_token(%{role_name: "Manager"})
{:ok, m2} = GeoTasksDb.create_new_token(%{role_name: "Manager"})
GeoTasksDb.create_new_token(%{role_name: "Manager"})

{:ok, d1} = GeoTasksDb.create_new_token(%{role_name: "Driver"})
{:ok, d2} = GeoTasksDb.create_new_token(%{role_name: "Driver"})
{:ok, d3} = GeoTasksDb.create_new_token(%{role_name: "Driver"})
GeoTasksDb.create_new_token(%{role_name: "Driver"})
GeoTasksDb.create_new_token(%{role_name: "Driver"})

GeoTasksDb.activate_token(d1.id)
GeoTasksDb.activate_token(d2.id)
GeoTasksDb.activate_token(d3.id)

GeoTasksDb.activate_token(m1.id)
GeoTasksDb.activate_token(m2.id)