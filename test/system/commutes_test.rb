require "application_system_test_case"

class CommutesTest < ApplicationSystemTestCase
  setup do
    @commute = commutes(:one)
  end

  test "visiting the index" do
    visit commutes_url
    assert_selector "h1", text: "Commutes"
  end

  test "creating a Commute" do
    visit commutes_url
    click_on "New Commute"

    fill_in "Label", with: @commute.label
    click_on "Create Commute"

    assert_text "Commute was successfully created"
    click_on "Back"
  end

  test "updating a Commute" do
    visit commutes_url
    click_on "Edit", match: :first

    fill_in "Label", with: @commute.label
    click_on "Update Commute"

    assert_text "Commute was successfully updated"
    click_on "Back"
  end

  test "destroying a Commute" do
    visit commutes_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Commute was successfully destroyed"
  end
end
