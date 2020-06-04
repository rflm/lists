const axios = require('axios');

const handleItemDestroy = link => {
  const li = link.closest('li');
  li.remove();
}

const apiCall = link => {
  axios.delete(link.dataset.url)
  .then(() => handleItemDestroy(link))
  .catch(() => handleItemDestroy(link));
}

export default () => {
  document.addEventListener('click', e => {
    const isRemoveLink =
      e && e.target && e.target.closest('a') &&
      e.target.closest('a').classList.contains('remove-link-js')

    if (!isRemoveLink) { return; }

    e.stopPropagation();

    const link = e.target.closest('a');
    const msg = link.dataset.confirm;

    if (confirm(msg)) {
      apiCall(link);
    }
  });
};
