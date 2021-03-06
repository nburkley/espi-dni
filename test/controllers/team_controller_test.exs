defmodule EspiDni.TeamControllerTest do
  use EspiDni.ConnCase

  import EspiDni.Factory
  @valid_attrs %{slack_id: "some content", slack_token: "some content", name: "teamname", url: "some content"}
  @invalid_attrs %{slack_token: "", slack_id: "", name: ""}

  setup do
     team = insert(:team)
     user = insert(:user)

    conn =
      build_conn
      |> assign(:current_user, user)
      |> assign(:current_team, team)

    {:ok, conn: conn, team: team}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, team_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing teams"
  end

  test "shows chosen resource", %{conn: conn, team: team} do
    conn = get conn, team_path(conn, :show, team)
    assert html_response(conn, 200) =~ "Show team"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, team_path(conn, :show, -1)
    end
  end
end
