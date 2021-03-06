defmodule EspiDni.Repo.Migrations.CreateNotificationMessage do
  use Ecto.Migration

  def change do
    create table(:notification_messages) do
      add :text, :string, null: false
      add :type, :string, null: false
      add :team_id, references(:teams, on_delete: :nothing)

      timestamps()
    end
    create index(:notification_messages, [:team_id])

  end
end
