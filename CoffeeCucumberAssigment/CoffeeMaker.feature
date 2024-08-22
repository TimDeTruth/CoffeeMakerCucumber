Feature: CoffeeMakerFeature

  In this feature, we are going to test the user stories and use cases for the CoffeeMaker Example. We have provided a CoffeeMakerMain.java file that you can use to examine the modal behavior in the coffee maker and issue UI commands to use it, so that we can adequately test the user stories.

  Hints: to catch the mistakes, you might need to add out of range cases for recipes and amounts of ingredients. Also, be sure to check machine state after running the user story:
    - Are the amounts of ingredients correct?
    - Is the system in the right mode?
    - Is the status what you expect?
    - Is the change produced correct?
    - etc.

  Scenario Outline: Waiting State
    Priority: 1 
    Story Points: 2

    If the Coffee Maker is not in use it waits for user input. There are six different options of user input: 1) add recipe, 2) delete a recipe, 3) edit a recipe, 4) add inventory, 5) check inventory, and 6) purchase beverage.

    For this scenario, what we will do is try each of the six user inputs and make sure that the coffee maker ends up in the appropriate mode. This would be a good place for a scenario outline with a table that described user inputs and expected final states.

    You might also want to try a couple of exceptional values to see what the Coffee Maker does.

    Given a default recipe book
    When I entered the option <userInput>
    Then the coffee maker should return to the <mode> mode

    Examples:
    | userInput | | mode 							|
    | 1         | | ADD_RECIPE 				|
    | 2         | | DELETE_RECIPE	 		|
    | 3         | | EDIT_RECIPE 			|
    | 4         | | ADD_INVENTORY 		|
    | 5         | | CHECK_INVENTORY 	|
    | 6         | | PURCHASE_BEVERAGE |
    | -5        | | WAITING 					|


  Scenario: Add a Recipe
    Priority: 1 
    Story Points: 2

    Only three recipes may be added to the CoffeeMaker. A recipe consists of a name, price, units of coffee, units of milk, units of sugar, and units of chocolate. Each recipe name must be unique in the recipe list. Price must be handled as an integer. A status message is printed to specify if the recipe was successfully added or not. Upon completion, the CoffeeMaker is returned to the waiting state.

    For this scenario, you should try to add a recipe to the recipe book, and check to see whether the coffee maker returns to the Waiting state.

    Given an empty recipe book
    When user submits a recipe
      | name   |   | price |   | amtCoffee |   | amtMilk |   | amtSugar |   | amtChocolate |
      | Coffee |   | 20    |   | 5         |   | 3       |   | 2        |   | 1            |
    Then the coffee maker should return to the WAITING mode
    And the status should be OK

  Scenario: Add a Recipe which already existed
    Given an empty recipe book
    When user submits a recipe
      | name   |   | price |   | amtCoffee |   | amtMilk |   | amtSugar |   | amtChocolate |
      | Coffee |   | 15    |   | 5         |   | 3       |   | 1        |   | 1            |
      | Coffee |   | 15    |   | 5         |   | 3       |   | 1        |   | 1            |
    Then the coffee maker should return to the WAITING mode
    And the status should be RECIPE_NOT_ADDED

  Scenario: Add a Recipe with wrong input
    Given an empty recipe book
    When user submits a recipe
      | name   |   | price |   | amtCoffee |   | amtMilk |   | amtSugar |   | amtChocolate |
      | Matcha |   | 15    |   | 5         |   | 3       |   | 1        |   | 1            |
    Then the coffee maker should return to the WAITING mode
    And the status should be OK

  Scenario: Delete a Recipe
    Priority: 2 
    Story Points: 1

    A recipe may be deleted from the CoffeeMaker if it exists in the list of recipes in the CoffeeMaker. The recipes are listed by their name. Upon completion, a status message is printed and the Coffee Maker is returned to the waiting state.

    Given a default recipe book
    When user delete Recipe 1
    Then the coffee maker should return to the WAITING mode
    And the status should be OK

  Scenario: Delete an Recipe out of range 1
    Given an empty recipe book
    When user delete Recipe 6
    Then the coffee maker should return to the WAITING mode
    And the status should be OUT_OF_RANGE

  Scenario: Edit a Recipe
    Priority: 2 
    Story Points: 1

    A recipe may be edited in the CoffeeMaker if it exists in the list of recipes in the CoffeeMaker. The recipes are listed by their name. After selecting a recipe to edit, the user will then enter the new recipe information. A recipe name may not be changed. Upon completion, a status message is printed and the Coffee Maker is returned to the waiting state.

    Given a default recipe book
    When user edits recipe 0
    Then check updated recipe 0
    And the coffee maker should return to the WAITING mode
    And the status should be OK

  Scenario: Edit a Recipe out of range 1
    Given an empty recipe book
    When user edits recipe -10 which doesn't exist
    And the coffee maker should return to the WAITING mode
    And the status should be OUT_OF_RANGE





  Scenario: Add Inventory
      Priority: 1 Story Points: 2

      Inventory may be added to the machine at any time from the main menu, and is added to
      the current inventory in the CoffeeMaker. The types of inventory in the CoffeeMaker are
      coffee, milk, sugar, and chocolate. The inventory is measured in integer units. Inventory
      may only be removed from the CoffeeMaker by purchasing a beverage. Upon completion, a
      status message is printed and the CoffeeMaker is returned to the waiting state.

   Given an empty recipe book
   When user add inventory
   | coffee | | milk | | sugar | | chocolate |
   |  10    | |  20  | |   30  | |   40      |
   Then check inventory
   | coffee | | milk | | sugar | | chocolate |
   |  25    | |  35  | |   45  | |   55      |
   And the coffee maker should return to the WAITING mode
   And the status should be OK







  Scenario: Check Inventory
      Priority: 2 Story Points: 1

      Inventory may be checked at any time from the main menu. The units of each item in the
      inventory are displayed. Upon completion, the Coffee Maker is returned to the waiting state.

   Given an empty recipe book
   When I entered the option 5
   Then check inventory
   | coffee | | milk | | sugar | | chocolate |
   |  15    | |  15  | |   15  | |   15      |
   And the coffee maker should return to the CHECK_INVENTORY mode
   And the status should be OK



  Scenario: Edit a Recipe
    Priority: 2
    Story Points: 1

    Given a default recipe book
    When the user edits recipe 1
    Then check updated recipe 1
    And the coffee maker should return to the WAITING mode
    And the status should be OK

  Scenario: Purchase Beverage
    Priority: 1
    Story Points: 2

    Given a default recipe book
    When the user inserts money 100
    And the user purchases coffee 0
    Then check inventory
      | Ingredient | Quantity |
      | coffee     | 12       |
      | milk       | 14       |
      | sugar      | 14       |
      | chocolate  | 15       |
    And the coffee maker should return to the WAITING mode
    And the status should be OK
    And we should take money from the tray 70

  Scenario: Purchase Beverage not enough money
    Given a default recipe book
    When the user inserts money 50
    And the user purchases coffee 0
    Then the coffee maker should return to the WAITING mode
    And the status should be INSUFFICIENT_FUNDS

  Scenario: Purchase Beverage not enough coffee inventory
    Given a default recipe book
    When the user inserts money 50
    And the user purchases coffee 1
    Then the coffee maker should return to the WAITING mode
    And the status should be INSUFFICIENT_FUNDS

# Add scenarios from the Use Cases here.  These can be Cucumber versions of the unit
# tests that were required for course 1, or can be more direct expressions of the use
# case tests found in the Requirements-coffeemaker.pdf file.

