
public class Main {
	public static void main(String[] args) {
		long startTime = System.currentTimeMillis();
		int n = 4096;
		int[] previousLine = new int[1];
		previousLine[0] = 1;
		int[] currentLine;		
		for(int i = 1; i < n; i++){
			currentLine = new int[previousLine.length+1];
			currentLine[0] = 1;
			currentLine[currentLine.length-1] = 1;
			for(int m = 1; m < currentLine.length-1; m++){
				currentLine[m] = previousLine[m-1] + previousLine[m];
			}
			if(i == n-1){
				for(int j = 0; j < currentLine.length; j++){
					System.out.print(currentLine[j] + " ");
				}
				System.out.println();
			}
			previousLine = currentLine;
		}		
		long stopTime = System.currentTimeMillis();
		System.out.println("Elapsed Time: " + (stopTime - startTime) + " milliseconds");
	}
}
