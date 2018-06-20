({
	transformCommunityData : function(data) 
    {
		return data.Status__c;
	},
    
    transformResourceData : function(data) 
    {
       'use strict'

       function fileSize(arg) 
       {
		var descriptor = arguments[1] === undefined ? {} : arguments[1];

    	var si = ["B", "kB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
 
		var result = [];
		var val = 0;
		var e = undefined,
		    ceil = undefined,
		    neg = undefined,
		    num = undefined,
		    output = undefined,
		    round = undefined,
		    unix = undefined,
		    spacer = undefined,
		    suffixes = undefined;

		if (isNaN(arg)) {
			throw new Error("Invalid arguments");
		}

		unix = descriptor.unix !== false;
		round = descriptor.round !== undefined ? descriptor.round : unix ? 1 : 1;
		spacer = descriptor.spacer !== undefined ? descriptor.spacer : unix ? "" : "";
		suffixes = descriptor.suffixes !== undefined ? descriptor.suffixes : {};
		output = descriptor.output !== undefined ? descriptor.output : "string";
		e = descriptor.exponent !== undefined ? descriptor.exponent : -1;
		num = Number(arg);
		neg = num < 0;
		ceil = 1000;

		// Flipping a negative number to determine the size
		if (neg) {
			num = -num;
		}

		// Zero is now a special case because bytes divide by 1
		if (num === 0) {
			result[0] = 0;

			if (unix) {
				result[1] = "";
			} else {
				result[1] = "B";
			}
		} else {
			// Determining the exponent
			if (e === -1 || isNaN(e)) {
				e = Math.floor(Math.log(num) / Math.log(ceil));
	    }

		// Exceeding supported length, time to reduce & multiply
		if (e > 8) {
		   val = val * (1000 * (e - 8));
		   e = 8;
		}
			
        val = num / Math.pow(1000, e);

		result[0] = Number(val.toFixed(e > 1 ? round : 0));
		result[1] = si[e];

		if (unix) {

		result[1] = result[1].charAt(0);

		if (result[1] === "B") {
		   result[0] = Math.floor(result[0]);
		   result[1] = " bytes";
			}
		  }
		}

		// Decorating a 'diff'
		if (neg) {
			result[0] = -result[0];
		}

		// Applying custom suffix
		result[1] = suffixes[result[1]] || result[1];

		// Returning Array, Object, or String (default)
		if (output === "array") {
			return result;
		}

		if (output === "exponent") {
			return e;
		}

		if (output === "object") {
			return { value: result[0], suffix: result[1] };
		}

		return result.join(spacer);
       }

        data.forEach(function(res){
          var a = res.file;
          if (!a) return;
          a.lengthString = fileSize(a.BodyLength)
          a.downloadLink = '/servlet/servlet.FileDownload?file='+a.Id;
        });
		return data;
	},
   
})