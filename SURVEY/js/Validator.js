var Validator = {
    debug: true,
    
    log: function(text) {
        if (this.debug)
            console.log(text);
    },
    
    rowValidate: function (row) {
        this.log("Validate row: passed!");
        this.log('implment validate rule here');
        
        return true;
    }
};