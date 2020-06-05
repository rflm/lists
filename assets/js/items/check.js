const axios = require('axios');

const handleItemCheckboxChange = (checkbox) => {
  const url = checkbox.checked ? checkbox.dataset.checkUrl : checkbox.dataset.uncheckUrl;

  axios.post(url);

  const description = checkbox.closest('li').getElementsByClassName('description')[0];

  if (checkbox.checked) {
    const s = document.createElement('s');

    s.textContent = description.dataset.description;
    description.textContent = '';

    description.appendChild(s);
  } else {
    description.textContent = description.dataset.description;
  }
};

export default () => {
  document.addEventListener('change', (e) => {
    const isItemCheckbox = e && e.target && e.target.classList.contains('item-checkbox');

    if (!isItemCheckbox) { return; }

    handleItemCheckboxChange(e.target);
  });
};
