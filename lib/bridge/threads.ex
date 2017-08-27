defmodule Bridge.Threads do
  @moduledoc """
  Threads are where all conversations take place. Recipients can include
  individual users as well as groups of users.
  """

  alias Bridge.Repo
  alias Bridge.Threads.Draft

  import Bridge.Gettext

  @doc """
  Build a changeset for creating a new draft.
  """
  def create_draft_changeset(params \\ %{}) do
    Draft.create_changeset(%Draft{}, params)
  end

  @doc """
  Create a new draft from a changeset.
  """
  def create_draft(changeset) do
    Repo.insert(changeset)
  end

  @doc """
  Fetches a draft by id and returns nil if not found.
  """
  def get_draft(id) do
    Repo.get(Draft, id)
  end

  @doc """
  Fetches a draft by id and returns nil if not found.
  """
  def get_draft_for_user(user, id) do
    Repo.get_by(Draft, %{id: id, user_id: user.id})
  end

  @doc """
  Build a changeset for updating a draft.
  """
  def update_draft_changeset(draft, params \\ %{}) do
    Draft.update_changeset(draft, params)
  end

  @doc """
  Updates a draft from a changeset.
  """
  def update_draft(%Ecto.Changeset{} = changeset) do
    Repo.update(changeset)
  end

  @doc """
  Updates a draft from a map of params.
  """
  def update_draft(draft, params \\ %{}) do
    draft
    |> update_draft_changeset(params)
    |> Repo.update()
  end

  @doc """
  Deletes a draft by id.
  """
  def delete_draft(id) do
    case get_draft(id) do
      nil ->
        {:error, dgettext("errors", "Draft not found")}
      draft ->
        case Repo.delete(draft) do
          {:error, _} ->
            {:error, dgettext("errors", "An unexpected error occurred")}
          success ->
            success
        end
    end
  end

  @doc """
  Generates the recipient ID for a resource able to be specified as a thread
  recipient.
  """
  def get_recipient_id(%Bridge.Teams.User{id: id}) do
    "u:#{id}"
  end
end