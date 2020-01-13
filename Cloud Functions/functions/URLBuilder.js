class URLBuilder {

    static url(day) {
        return URLBuilder.BASE_URL + this.suffixFor(day)
    }

    static suffixFor(daysInFuture) {
        let date = this.todayPlus(daysInFuture);

        let day = date.getDate().toString(10);
        let year = date.getFullYear().toString(10);

        let month;
        switch (date.getMonth()) {
            case 0: month = "January"; break;
            case 1: month = "February"; break;
            case 2: month = "March"; break;
            case 3: month = "April"; break;
            case 4: month = "May"; break;
            case 5: month = "June"; break;
            case 6: month = "July"; break;
            case 7: month = "August"; break;
            case 8: month = "September"; break;
            case 9: month = "October"; break;
            case 10: month = "November"; break;
            case 11: month = "December"; break;
        }

        return month.concat("+", day, "%2C+", year)
    }

    static todayPlus(numberOfDays) {
        let today = new Date();
        // note that this won't be quite right at times, like when Daylight Saving starts
        return new Date(today.getTime() + numberOfDays*24*60*60*1000);
    }
}

URLBuilder.BASE_URL = "https://hospitality.usc.edu/residential-dining-menus/?menu_date=";
URLBuilder.Days = {
    TODAY: 0,
    TOMORROW: 1,
    THENEXTDAY: 2
};

module.exports = URLBuilder;