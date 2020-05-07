const axios = require('axios');
const newItemForm = document.getElementById('new-item-form');
const itemsList = document.getElementById('items-list');

const removePreviousErrors = () => {
  const formGroup = input.closest('.form-group');
  const errors = formGroup.getElementsByClassName('invalid-feedback')

  while(errors.length > 0) {
    errors[0].parentNode.removeChild(errors[0]);
  }
}

const buildNewItem = item => {
  const template = document.getElementById('item-template');
  const clone = template.content.cloneNode(true);
  const li = clone.querySelector('li');
  const description = li.getElementsByClassName('description')[0];

  description.textContent = item.description;
  description.dataset.description = item.description;

  const removeLink = li.getElementsByClassName('remove-link-js')[0];
  removeLink.dataset.url = removeLink.dataset.url.replace('-id-', item.id)

  const checkbox = li.getElementsByClassName('item-checkbox')[0];
  checkbox.dataset.checkUrl = checkbox.dataset.checkUrl.replace('-id-', item.id)
  checkbox.dataset.uncheckUrl = checkbox.dataset.uncheckUrl.replace('-id-', item.id)

  return li;
}

const handleItemSaveSuccess = item => {
  const li = buildNewItem(item)
  itemsList.appendChild(li);

  const submitBtn = newItemForm.getElementsByTagName('button')[0];
  submitBtn.removeAttribute('disabled');

  const input = newItemForm.getElementsByClassName('description')[0]
  input.value = '';
  input.classList.remove('is-invalid');

  removePreviousErrors();
}

const handleItemSaveFail = error => {
  removePreviousErrors();

  error.errors.forEach(error => {
    if (error.description.length) {
      const input = newItemForm.getElementsByClassName('description')[0]
      input.classList.add('is-invalid');

      const feedback = document.createElement('div');
      feedback.classList.add('invalid-feedback');
      feedback.textContent = error.description;

      const formGroup = input.closest('.form-group');
      formGroup.appendChild(feedback);
    }
  });

  const submitBtn = newItemForm.getElementsByTagName('button')[0];
  submitBtn.removeAttribute('disabled');
}

const handleSubmit = () => {
  const submitBtn = newItemForm.getElementsByTagName('button')[0];
  submitBtn.setAttribute('disabled', '');

  const { url } = newItemForm.dataset;
  const input = newItemForm.getElementsByClassName('description')[0]

  axios.post(url, {
    description: input.value
  })
  .then(({ data }) => handleItemSaveSuccess(data))
  .catch(({ response }) => handleItemSaveFail(response.data));
}

export default () => {
  if (!newItemForm) { return; }

  newItemForm.addEventListener('submit', e => {
    e.preventDefault();
    handleSubmit();
  })
}
