defmodule EspiDni.AuthHandler do

  @moduledoc """
  Create or retreive the team and user from an auth request
  """
  alias Ueberauth.Auth
  alias EspiDni.TeamFromAuth
  alias EspiDni.UserFromAuth

  def init_from_auth(%Auth{} = auth) do
    with {:ok, team} <- TeamFromAuth.find_or_create(auth),
         {:ok, user} <- UserFromAuth.find_or_create(auth, team) do
      {:ok, team, user}
    end
    |> case do
        {:ok, team, user} -> {:ok, team, user}
        {:error, changeset} -> {:error, changeset}
      end
  end

end