const he = require('he');

class MenuBuilder {

    constructor() {
        this.menu = [];

        this.currentMeal = null;
        this.currentHall = null;
        this.currentSect = null;
        this.currentFood = null;

        this.readingMeal = false;
        this.readingHall = false;
        this.readingSect = false;
        this.readingFood = false;
    }

    processNewText(text) {
        // NOTE: this method relies on currentMeal, currentHall, currentSect, and currentFood being set to nil upon successful population

        // when readingMeal becomes true, use first encountered text as meal name
        if (this.readingMeal) {
            if (this.mealIsNil()) this.initializeMeal(text);
            // when readingHall becomes true, use first encountered text as hall name
            else if (this.readingHall) {
                if (this.hallIsNil()) this.initializeHall(text);
                // when readingSect becomes true, use first encountered text as sect name
                else if (this.readingSect) {
                    if (this.sectIsNil()) this.initializeSect(text);
                    // when readingFood becomes true, use first encountered text as food name
                    else if (this.readingFood) {
                        if (this.foodIsNil()) {this.initializeFood(text);}
                        // use other text to populate allergens
                        else {this.currentFood.allergens.push(text);}
                    }
                }
            }
        }
    }

    processNewTag(tag) {
        switch (tag) {
            case MenuBuilder.HTMLMeal.startTag:
                this.saveMeal();
                this.resetMeal(); this.resetHall(); this.resetSect(); this.resetFood();
                break;

            case MenuBuilder.HTMLHall.startTag: if (this.readingMeal) this.readingHall = true; break;
            case MenuBuilder.HTMLSect.startTag: if (this.readingHall) this.readingSect = true; break;
            case MenuBuilder.HTMLFood.startTag: if (this.readingSect) this.readingFood = true; break;
            case MenuBuilder.HTMLFood.endTag: if (this.readingFood) {this.saveFood(); this.resetFood();} break;
            case MenuBuilder.HTMLSect.endTag: if (this.readingSect) {this.saveSect(); this.resetSect();} break;
            case MenuBuilder.HTMLHall.endTag: if (this.readingHall) {this.saveHall(); this.resetHall();} break;
        }
    }

    mealIsNil() {return this.currentMeal === null;}
    hallIsNil() {return this.currentHall === null;}
    sectIsNil() {return this.currentSect === null;}
    foodIsNil() {return this.currentFood === null;}

    initializeMeal(name) {this.currentMeal = new MenuBuilder.HTMLMeal(name, []);}
    initializeHall(name) {this.currentHall = new MenuBuilder.HTMLHall(name, []);}
    initializeSect(name) {this.currentSect = new MenuBuilder.HTMLSect(name, []);}
    initializeFood(name) {this.currentFood = new MenuBuilder.HTMLFood(name, []);}

    saveMeal() {
        if (!this.mealIsNil() && this.currentMeal.halls.length === 3) {
            this.menu.push(this.currentMeal);
        }
    }
    saveHall() {if (!this.hallIsNil()) this.currentMeal.halls.push(this.currentHall);}
    saveSect() {if (!this.sectIsNil()) this.currentHall.sects.push(this.currentSect);}
    saveFood() {if (!this.foodIsNil()) this.currentSect.foods.push(this.currentFood);}

    resetMeal() {this.currentMeal = null; this.readingMeal = true;}
    resetHall() {this.currentHall = null; this.readingHall = false;}
    resetSect() {this.currentSect = null; this.readingSect = false;}
    resetFood() {this.currentFood = null; this.readingFood = false;}
}

MenuBuilder.HTMLMeal = class {
    constructor(name, halls) {
        this.name = name;
        this.halls = halls;
    }

    shortName() {
        // e.g. "Breakfast"
        return this.name.split(" ")[0];
    }

    dateText() {
        // MMMM d, YYYY
        return this.name.split("- ")[1];
    }
};
MenuBuilder.HTMLMeal.startTag = "<span class=\"fw-accordion-title-inner\">";

MenuBuilder.HTMLHall = class {
    constructor(name, sects) {
        this.name = name;
        this.sects = sects;
    }

    decodedName() {
        return he.decode(this.name)
    }
};
MenuBuilder.HTMLHall.startTag = "<h3 class=\"menu-venue-title\">";
MenuBuilder.HTMLHall.endTag = "</div>";

MenuBuilder.HTMLSect = class {
    constructor(name, foods) {
        this.name = name;
        this.foods = foods;
    }

    shortName() {
        return this.name.replace('/', ' ').replace(/[^a-z0-9 ]/gi,'')
    }
}
MenuBuilder.HTMLSect.startTag = "<h4>";
MenuBuilder.HTMLSect.endTag = "</ul>";

MenuBuilder.HTMLFood = class {
    constructor(name, allergens) {
        this.name = name;
        this.allergens = allergens;
    }
};
MenuBuilder.HTMLFood.startTag = "<li>";
MenuBuilder.HTMLFood.endTag = "</li>";

module.exports = MenuBuilder;