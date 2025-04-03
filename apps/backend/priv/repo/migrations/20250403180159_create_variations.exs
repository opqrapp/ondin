defmodule Ondin.Repo.Migrations.CreateVariations do
  use Ecto.Migration

  def change do
    # Variations are now stored directly in the rules and features tables as a map field
    # This migration is kept as a placeholder for potential future enhancements
  end
end
