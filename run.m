clear all;
clc;

%% Possible values: hebbian, anti_hebbian, random_walk
update_rule = 'hebbian';

%% Machine Parameters
k = 4;
n = 4;
l = 4;
%%
Alice = machine(k, n, l);
Bob = machine(k, n, l);
Eve = machine(k, n, l);

%%
sync = 0; % Flag to check if weights are sync
nb_updates = 0; % Update counter
nb_eve_updates = 0; % To count the number of times eve updated
sync_history = []; % to store the sync score after every update
tic
%%
figure('units','normalized','outerposition',[0 0 1 1])
while(not(sync))
    X = randi([-l l],k,n);
	tauA = Alice.get_output(X); % Get output from Alice
	tauB = Bob.get_output(X); % Get output from Bob
	tauE = Eve.get_output(X); % Get output from Eve 
    
    Alice.update(tauB, update_rule); % Update Alice with Bob's output
	Bob.update(tauA, update_rule); % Update Bob with Alice's output
    
 	%Eve would update only if tauA = tauB = tauE
	if(tauA == tauB == tauE)
		Eve.update(tauA, update_rule);
		nb_eve_updates = nb_eve_updates + 1;  
    end
    nb_updates = nb_updates + 1;
    score = 100 * sync_score(Alice, Bob,l) % Calculate the synchronization of the 2 machines
    
    sync_history = [sync_history score];
    
     if(score == 100)
         sync = 1;
     end
     pause(0.001)
     imagesc(Alice.W - Bob.W,[-l,l])
     title('SYNCHRONIZATION OF MACHINE WEIGHTS')
     xlabel('Input')
     ylabel('Hidden Neuron')
end

%See if Eve got what she wanted:
eve_score = round(100 * (sync_score(Alice, Eve,l)))
if eve_score > 100
    disp('Oops! Nosy Eve synced her machine with Alice and Bob !')
else
    disp(strcat('Eves machine is only ',num2str(eve_score),'% ', 'synced with Alices and Bobs and she did  ',num2str(nb_eve_updates),' updates'));
end
%%
figure('units','normalized','outerposition',[0 0 1 1])
plot(sync_history)
title('SYNCHRONIZATION SCORE')
xlabel('Number of Updates')
ylabel('Sync Score')
toc