from random import randint

def main():
	results, n_rolls = [], []
	trials, counter = 100000, 0
	while(counter<trials):
		trial = death_save()
		results.append(trial[0])
		n_rolls.append(trial[1])
		counter += 1
		
	print(sum(results)/trials)
	print(sum(n_rolls)/trials)
	
def death_save():
	live, die, n_rolls = 0, 0, 0
	while True:
		roll = randint(1, 20)
		n_rolls += 1
		if roll == 1:
			die += 2
		elif roll == 20:
			live += 3
		elif roll > 1 and roll < 10:
			die += 1
		else:
			live += 1
		
		if live >= 3:
			return [1, n_rolls]
		elif die >= 3:
			return [0, n_rolls]
	
	
if __name__ == '__main__':
	main()
