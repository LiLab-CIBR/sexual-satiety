classdef (ConstructOnLoad) NeuronSource < dynamicprops
    properties
        intruder_action
        action_label_extend
        intruder_action2
    end
    methods
        function obj = NeuronSource(neuron)
            PROPERTINAMES={'light', 'intruder', 'intruder_label', 'action_label', ...
                'gender','color', 'Fs', 'name', 'neuron_id', 'num_neuron', 'nframe', 'events'};
            for i = 1:length(PROPERTINAMES)
                PROP = PROPERTINAMES{i};
                addprop(obj, PROP);
                obj.(PROP) = neuron.(PROP);
            end
            obj.remap_events();
            obj.action_label_extend = [obj.action_label, 'Light', 'PreResting'];
            obj.refine_prerest();
        end
        function refine_prerest(neuron)
            intrudert = neuron.intruder;
            lightt = neuron.light;
            nintru = size(intrudert,1);
            lightsession = cell(nintru, 1);
            lightpre = cell(nintru, 1);
            nact = length(neuron.action_label);
            for ii = 1:nintru
                intru_bg = intrudert(ii, 1);
                intru_end = intrudert(ii, 2);
                ind = intru_bg >= lightt(:,1) & intru_end <=lightt(:,2);
                assert(sum(ind) == 1);
                lightsession{ii} = lightt(ind, :);
                lightpre{ii} = [lightt(ind,1), intru_bg];
            end
            lightpre_mat = cell2mat(lightpre);
            for ii=1:nintru
                pre_ii = lightpre_mat(ii,1);
                ind = pre_ii == lightpre_mat(:,1);
                if length(ind)>2
                    lightpre_mat(ind,2) = min(lightpre_mat(ind,2));
                end
            end
            lightpre = mat2cell(lightpre_mat, ones(nintru, 1));
            neuron.intruder_action(:, nact+1) = lightsession;
            neuron.intruder_action(:, nact+2) = lightpre;
        end
        function remap_events(neuron)
            intrudert = neuron.intruder;
            actiont = neuron.events;
            nintru = size(intrudert,1);
            nact = length(actiont);
            neuron.intruder_action = cell(nintru, nact);
            neuron.intruder_action2 = cell(nintru, nact);
            for ii = 1:nintru
                intru_bg = intrudert(ii, 1);
                intru_end = intrudert(ii, 2);
                for ia = 1:nact
                    act_now = actiont{ia}(:,1);
                    act_end = actiont{ia}(:,2);
                    indact = act_now >= intru_bg & act_now <= intru_end;
                    neuron.intruder_action{ii, ia} = act_now(indact, :);
                    neuron.intruder_action2{ii, ia} = act_end(indact, :);
                end
            end
        end
        function show(obj)
            obj.show_intruderaction();
            obj.show_patch();
        end
        function show_patch(neuron)
             plot_data(zeros(2,neuron.nframe), neuron, {1}, 'deconv', 'zeroline');
             set(gca, 'position',[0.03 0.21 0.96 0.68]);
             ylabel('');
        end 
        function show_intruderaction(neuron)
            intrudert = neuron.intruder;
            actiont = neuron.events;
            nintru = size(intrudert,1);
            nact = length(actiont);
            labels = cell(nact+2, nintru);
            labels(1,:) = neuron.intruder_label;
            labels(2,:) = {'------'};
            labels(3:end,:) = {' '};

            for ii = 1:nintru
                intru_bg = intrudert(ii, 1);
                intru_end = intrudert(ii, 2);
                ind_row = 1;
                for ia = 1:nact
                    act_now = actiont{ia}(:,1);
                    indact = act_now > intru_bg & act_now < intru_end;
                    if(any(indact))
                        labels{ind_row+2, ii} = sprintf('%s (%d)', neuron.action_label{ia}, sum(indact));
                        ind_row = ind_row+1;
                    end
                end
            end
            disp(labels);
        end
    end
end