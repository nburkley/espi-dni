defmodule EspiDni.SlackArticleControllerTest do
  use EspiDni.ConnCase

  setup do
    user = insert_team |> insert_user
    {:ok, conn: conn, user: user}
  end

  test "returns a 401 for an invalid token", %{conn: conn} do
    params = %{command: "/add", token: "invalid"}
    conn = post conn, slack_article_path(conn, :new), params

    assert conn.status == 401
    assert conn.resp_body =~ "Unauthorized"
  end

  test "returns a 404 for an unknown user", %{conn: conn} do
    params = %{command: "/add", token: slack_token, user_id: "invalid"}
    conn = post conn, slack_article_path(conn, :new), params

    assert conn.status == 404
    assert conn.resp_body =~ "Unknown User"
  end

  test "returns a validation message for an invalid url", %{conn: conn, user: user} do
    params = %{command: "/add", token: slack_token, user_id: user.slack_id, text: "invalid_url"}
    conn = post conn, slack_article_path(conn, :new), params

    assert text_response(conn, 200) =~ "invalid_url is not a valid URL"
  end

  test "returns an article confirmation response", %{conn: conn, user: user} do
    params = %{command: "/add", token: slack_token, user_id: user.slack_id, text: "http://example.com" }
    conn = post conn, slack_article_path(conn, :new), params

    body = json_response(conn, 200)
    assert "Okay, you'd like to register the article at http://example.com?" =~ body["text"]
  end
end
