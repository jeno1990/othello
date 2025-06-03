import 'package:flutter/material.dart';
import 'package:othello/controllers/game_state_controller.dart';

class CountDashboard extends StatelessWidget {
  const CountDashboard({
    super.key,
    this.imageUrl,
    required this.name,
    required this.count,
    required this.isPlayer1,
    required this.isBot,
    required this.difficulty,
    required this.currentTurn,
  });
  final String? imageUrl;
  final String name;
  final int count;
  final bool isPlayer1;
  final bool isBot;
  final GameDifficulty difficulty;
  final bool currentTurn;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 20,
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:
              !currentTurn
                  ? [
                    const Color.fromARGB(255, 67, 66, 66),
                    Color.fromARGB(255, 135, 133, 133),
                  ]
                  : [
                    const Color.fromARGB(255, 49, 144, 46),
                    Color.fromARGB(255, 75, 241, 4),
                  ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black26, offset: Offset(0, 2), blurRadius: 4),
        ],
      ),
      child: Container(
        padding: EdgeInsets.all(5),

        decoration: BoxDecoration(
          border: Border.all(color: Colors.white54, width: 2),
          gradient: LinearGradient(colors: [Colors.black38, Colors.black]),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2),
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 11, 11, 11),
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: AssetImage(
                        isBot
                            ? 'assets/image/bot.jpg'
                            : imageUrl == null
                            ? 'assets/image/profile.jpg'
                            : imageUrl!,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isPlayer1 ? Colors.black : Colors.white,
                            border: Border.all(
                              color: isPlayer1 ? Colors.white : Colors.grey,
                              width: 2,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          isBot ? 'Computer' : name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    // Divider(color: Colors.white, thickness: 1),
                    SizedBox(height: 2),
                    Text(
                      isBot ? '${difficulty.name} Difficulty' : 'Canada',
                      style: TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(right: 10),
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white24, Colors.white54, Colors.black],
                ),
                shape: BoxShape.circle,
              ),
              child: Container(
                alignment: Alignment.center,
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 76, 72, 72),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
