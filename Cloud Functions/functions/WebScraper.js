const MenuBuilder = require('./MenuBuilder');

class WebScraper {
    constructor() {
        this.menuBuilder = new MenuBuilder();
    }

    scrape(html) {
        var readingTag = false;
        var currentTag = "";
        var currentNonTag = "";

        for (var i = 0; i < html.length; i++) {
            let char = html.charAt(i);

            if (char === '<') {
                readingTag = true;
                currentTag = "";

                if (currentNonTag.length > 0) this.menuBuilder.processNewText(currentNonTag);
                if (currentNonTag === "Legend") this.menuBuilder.saveMeal();
                currentNonTag = "";
            }

            if (readingTag) {currentTag = currentTag.concat(char);}
            else {currentNonTag = currentNonTag.concat(char);}

            if (char === '>') {
                readingTag = false;
                this.menuBuilder.processNewTag(currentTag)
            }
        }
    }
}

module.exports = WebScraper;