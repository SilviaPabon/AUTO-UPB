const container = document.querySelector('.generic-table').children[1].children;
const table = document.getElementById('input');

const postChange = (inputField) => {
    console.log(inputField.value);
};

for (let i = 0; i < container.length; i++) {
    container[i].querySelector('.btn--amount-b').addEventListener('click', (e) => {
        if (
            container[i].getElementsByTagName('input')[0].value <
            parseInt(container[i].getElementsByTagName('input')[0].attributes['max'].value)
        ) {
            console.log(container[i].getElementsByTagName('input')[0].value);
            container[i].getElementsByTagName('input')[0].value =
                parseInt(container[i].getElementsByTagName('input')[0].value) + 1;
            postChange(container[i].getElementsByTagName('input')[0]);
        }

        e.stopPropagation();
    });
    container[i].querySelector('.btn--amount-a').addEventListener('click', (e) => {
        if (
            container[i].getElementsByTagName('input')[0].value >
            parseInt(container[i].getElementsByTagName('input')[0].max)
        ) {
            container[i].getElementsByTagName('input')[0].value = parseInt(
                container[i].getElementsByTagName('input')[0].max
            );
        } else if (container[i].getElementsByTagName('input')[0].value > 1) {
            container[i].getElementsByTagName('input')[0].value =
                parseInt(container[i].getElementsByTagName('input')[0].value) - 1;
            postChange(container[i].getElementsByTagName('input')[0]);
        }
    });
    container[i].getElementsByTagName('input')[0].addEventListener('input', (e) => {
        if (
            container[i].getElementsByTagName('input')[0].value >
            parseInt(container[i].getElementsByTagName('input')[0].max)
        ) {
            container[i].getElementsByTagName('input')[0].value = parseInt(
                container[i].getElementsByTagName('input')[0].max
            );
        }
        postChange(e.target);
    });
}
