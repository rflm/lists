const axios = require('axios');
const newItemForm = document.getElementById('new-item-form');
const submitBtn = newItemForm.getElementsByTagName('button')[0];
const itemsList = document.getElementById('items-list');
const input = newItemForm.getElementsByClassName('description')[0]
const formGroup = input.closest('.form-group');

const removePreviousErrors = () => {
  const errors = formGroup.getElementsByClassName('invalid-feedback')

  while(errors.length > 0) {
    errors[0].parentNode.removeChild(errors[0]);
  }
}

const handleItemSaveSuccess = item => {
  const li = document.createElement('li')
  li.textContent = item.description
  itemsList.appendChild(li);

  submitBtn.removeAttribute('disabled');
  input.value = '';

  input.classList.remove('is-invalid');
  removePreviousErrors();
}

const handleItemSaveFail = error => {
  removePreviousErrors();

  error.errors.forEach(error => {
    if (error.description.length) {
      input.classList.add('is-invalid');
      const feedback = document.createElement('div');
      feedback.classList.add('invalid-feedback');
      feedback.textContent = error.description;


      formGroup.appendChild(feedback);
    }
  });

  submitBtn.removeAttribute('disabled');
}

const handleSubmit = () => {
  submitBtn.setAttribute('disabled', '');

  const { url } = newItemForm.dataset;

  axios.post(url, {
    description: input.value
  })
  .then(({ data }) => handleItemSaveSuccess(data))
  .catch(({ response }) => handleItemSaveFail(response.data));
}

export default () => {
  newItemForm.addEventListener('submit', e => {
    e.preventDefault();
    handleSubmit();
  })
}
