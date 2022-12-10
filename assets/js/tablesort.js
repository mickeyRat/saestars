/**
 * Sorts a HTML table.
 * 
 * @param {HTMLTableElement} table The table to sort
 * @param {number} column The index of the column to sort
 * @param {boolean} asc Determines if the sorting will be in ascending
 */
function sortTableByColumn(table, column, dataType, asc = true) {
    const dirModifier = asc ? 1 : -1;
    // console.log('column = '+column);
    var x = table.tBodies[0];

    const tBody = table.tBodies[0];
    const rows = Array.from(tBody.querySelectorAll("tr"));
    // console.log(dataType);

    var sortedRows;
    if (dataType=='float'){
        sortedRows = rows.sort((a, b) => {
            // console.log(a);
            // console.log(b);
            const aColPrice = parseFloat(a.querySelector(`td:nth-child(${ column + 1 })`).textContent.trim());
            const bColPrice = parseFloat(b.querySelector(`td:nth-child(${ column + 1 })`).textContent.trim());
            
            return aColPrice > bColPrice ? (1 * dirModifier) : (-1 * dirModifier);
        });
    } else if (dataType=='int') {
        sortedRows = rows.sort((a, b) => {
            const aColPrice = parseInt(a.querySelector(`td:nth-child(${ column + 1 })`).textContent.trim());
            const bColPrice = parseInt(b.querySelector(`td:nth-child(${ column + 1 })`).textContent.trim());
            
            return aColPrice > bColPrice ? (1 * dirModifier) : (-1 * dirModifier);
        });
    } else {
        sortedRows = rows.sort((a, b) => {
            const aColText = a.querySelector(`td:nth-child(${ column + 1 })`).textContent.trim();
            const bColText = b.querySelector(`td:nth-child(${ column + 1 })`).textContent.trim();
    
            return aColText > bColText ? (1 * dirModifier) : (-1 * dirModifier);
        });
    }

    // Remove all existing TRs from the table
    while (tBody.firstChild) {
        tBody.removeChild(tBody.firstChild);
    }

    // Re-add the newly sorted rows
    tBody.append(...sortedRows);

    // Remember how the column is currently sorted
    table.querySelectorAll("th").forEach(th => th.classList.remove("th-sort-asc", "th-sort-desc"));
    table.querySelector(`th:nth-child(${ column + 1})`).classList.toggle("th-sort-asc", asc);
    table.querySelector(`th:nth-child(${ column + 1})`).classList.toggle("th-sort-desc", !asc);
}

