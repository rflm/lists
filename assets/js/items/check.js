const axios = require('axios');

const handleItemCheckboxChange = checkbox => {
  const url =
    checkbox.checked ? checkbox.dataset.checkUrl : checkbox.dataset.uncheckUrl;

  axios.post(url);
};

export default () => {
  document.addEventListener('change', e => {
    const isItemCheckbox =
      e && e.target && e.target.classList.contains('item-checkbox');

    if (!isItemCheckbox) { return; }

    handleItemCheckboxChange(e.target);
  });
};
