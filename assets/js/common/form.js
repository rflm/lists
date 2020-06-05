const axios = require('axios');

const newItemForm = document.getElementById('new-item-form');
const newListForm = document.getElementById('new-list-form');

const itemsList = document.getElementById('items-list');
const listsList = document.getElementById('lists-list');

const removePreviousErrors = (form) => {
  const errors = form.getElementsByClassName('invalid-feedback');

  while (errors.length > 0) {
    errors[0].parentNode.removeChild(errors[0]);
  }
};

const buildNewItem = (item) => {
  const template = document.getElementById('item-template');
  const clone = template.content.cloneNode(true);
  const li = clone.querySelector('li');
  const description = li.getElementsByClassName('description')[0];

  description.textContent = item.description;
  description.dataset.description = item.description;

  const removeLink = li.getElementsByClassName('remove-link-js')[0];
  removeLink.dataset.url = removeLink.dataset.url.replace('-id-', item.id);

  const checkbox = li.getElementsByClassName('item-checkbox')[0];
  checkbox.dataset.checkUrl = checkbox.dataset.checkUrl.replace('-id-', item.id);
  checkbox.dataset.uncheckUrl = checkbox.dataset.uncheckUrl.replace('-id-', item.id);

  return li;
};

const buildNewList = (list) => {
  const template = document.getElementById('list-template');
  const clone = template.content.cloneNode(true);
  const li = clone.querySelector('li');
  const a = clone.querySelector('a');

  a.textContent = list.name;
  a.href = `/lists/${list.id}`;

  return li;
};

const handleSaveSuccess = (form, itemOrList) => {
  let li = null;
  let list = itemsList;

  if (form === newItemForm) { li = buildNewItem(itemOrList); }
  if (form === newListForm) {
    li = buildNewList(itemOrList);
    list = listsList;
  }

  list.appendChild(li);

  const submitBtn = form.getElementsByTagName('button')[0];
  submitBtn.removeAttribute('disabled');

  const input = form.querySelectorAll('.description, .name')[0];
  input.value = '';
  input.classList.remove('is-invalid');

  removePreviousErrors(form);
};

const handleSaveFail = (form, error) => {
  removePreviousErrors(form);

  error.errors.forEach((err) => {
    if (err.description || err.name) {
      const input = form.querySelectorAll('.description, .name')[0];
      input.classList.add('is-invalid');

      const feedback = document.createElement('div');
      feedback.classList.add('invalid-feedback');

      if (err.description) {
        feedback.textContent = err.description;
      }

      if (err.name) {
        feedback.textContent = err.name;
      }

      const formGroup = input.closest('.form-group');
      formGroup.appendChild(feedback);
    }
  });

  const submitBtn = form.getElementsByTagName('button')[0];
  submitBtn.removeAttribute('disabled');
};

const handleSubmit = (form) => {
  const submitBtn = form.getElementsByTagName('button')[0];
  submitBtn.setAttribute('disabled', '');

  const { url } = form.dataset;
  const input = form.querySelectorAll('.description, .name')[0];

  let params = { description: input.value };

  if (form === newListForm) {
    params = { name: input.value };
  }

  axios.post(url, params)
    .then(({ data }) => {
      handleSaveSuccess(form, data);
    })
    .catch(({ response }) => handleSaveFail(form, response.data));
};

export default () => {
  if (newItemForm) {
    newItemForm.addEventListener('submit', (e) => {
      e.preventDefault();
      handleSubmit(newItemForm);
    });
  }

  if (newListForm) {
    newListForm.addEventListener('submit', (e) => {
      e.preventDefault();
      handleSubmit(newListForm);
    });
  }
};
