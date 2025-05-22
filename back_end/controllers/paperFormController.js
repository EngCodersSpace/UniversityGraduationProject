// controllers/paperFormController.js

const {
    paper_form_type,
    paper_form_forward_step,
    paper_form,
    paper_form_activitie,
    user,
} = require('../models');
  
module.exports = {
    // Step 1: Create a new form type
    createFormType: async (req, res) => {
      try {
        const { name, code, description } = req.body;
        const formType = await paper_form_type.create({ name, code, description });
        res.status(201).json({ message: 'Form type created', data: formType });
      } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error', error });
      }
    },
  
    // Step 2: Add forward step(s) to a form type
    addForwardStep: async (req, res) => {
        try {
        const stepsData = req.body;
    
        // Normalize to array (handle both single object and array input)
        const steps = Array.isArray(stepsData) ? stepsData : [stepsData];
    
        const createdSteps = [];
    
        for (const step of steps) {
            const { form_type_id, step_order, user_id, is_final_step, not } = step;
    
            // Check form type existence
            const formType = await paper_form_type.findByPk(form_type_id);
            if (!formType) {
            return res.status(404).json({ message: `Form type ${form_type_id} not found` });
            }
    
            const created = await paper_form_forward_step.create({
            form_type_id,
            step_order,
            user_id,
            is_final_step: is_final_step || false,
            not,
            });
    
            createdSteps.push(created);
        }
    
        res.status(201).json({
            message: `${createdSteps.length} forward step(s) added`,
            data: createdSteps,
        });
    
        } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error', error });
        }
    },
    
  
    // Step 3: Student submits a paper form
    submitPaperForm: async (req, res) => {
      try {
        const { form_type_id, user_id, form_data } = req.body;
  
        // Check if form type exists
        const formType = await paper_form_type.findByPk(form_type_id);
        if (!formType) return res.status(404).json({ message: 'Form type not found' });
  
        // Find the first forward step (step_order = 1)
        const firstStep = await paper_form_forward_step.findOne({
          where: { form_type_id, step_order: 1 },
        });
  
        if (!firstStep) return res.status(400).json({ message: 'No forward step defined for this form type' });
  
        const newForm = await paper_form.create({
          form_type_id,
          user_id,
          form_data,
          status: 'pending',
          current_user_id: firstStep.user_id,
          current_step: 1,
        });
  
        res.status(201).json({ message: 'Form submitted', data: newForm });
      } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error', error });
      }
    },
  
    // Step 4: User takes action (approve/reject/comment) on a paper form
    takeAction: async (req, res) => {
      try {
        const { form_id } = req.params;
        const { user_id, action, comment } = req.body;
  
        const form = await paper_form.findByPk(form_id);
        if (!form) return res.status(404).json({ message: 'Form not found' });
  
        if (form.current_user_id !== user_id) {
          return res.status(403).json({ message: 'Not authorized to act on this form' });
        }
  
        // Log the action in paper_form_activitie
        await paper_form_activitie.create({
          form_id,
          user_id,
          action,
          comment,
        });
  
        // Get all forward steps for this form type ordered by step_order
        const steps = await paper_form_forward_step.findAll({
          where: { form_type_id: form.form_type_id },
          order: [['step_order', 'ASC']],
        });
  
        // Find the index of the current step
        const currentIndex = steps.findIndex((step) => step.step_order === form.current_step);
  
        if (action === 'approved') {
          // Move to next step or finalize
          if (currentIndex === steps.length - 1 || steps[currentIndex].is_final_step) {
            // This is the final step
            form.status = 'approved';
            form.current_step = 0;
            form.current_user_id = null;
          } else {
            // Move to next step
            const nextStep = steps[currentIndex + 1];
            form.current_step = nextStep.step_order;
            form.current_user_id = nextStep.user_id;
            form.status = 'pending';
          }
        } else if (action === 'rejected') {
          form.status = 'rejected';
          form.current_step = null;
          form.current_user_id = null;
        } else if (action === 'commented') {
          // Status stays pending, current step and user remain unchanged
        }
  
        await form.save();
  
        res.status(200).json({ message: 'Action recorded', form });
      } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error', error });
      }
    },
  
    // Step 5: Get form activities (history)
    getFormActivities: async (req, res) => {
      try {
        const { form_id } = req.params;
  
        const activities = await paper_form_activitie.findAll({
          where: { form_id },
          include: [{ model: user, attributes: ['user_id', 'user_name'] }],
          order: [['createdAt', 'ASC']],
        });
  
        res.status(200).json({ data: activities });
      } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server error', error });
      }
    },
};
  