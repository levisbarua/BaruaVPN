import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../models/vpn_state_model.dart';

class AnimatedConnectButton extends StatefulWidget {
  final VpnStatus status;
  final VoidCallback onTap;

  const AnimatedConnectButton({
    super.key,
    required this.status,
    required this.onTap,
  });

  @override
  State<AnimatedConnectButton> createState() => _AnimatedConnectButtonState();
}

class _AnimatedConnectButtonState extends State<AnimatedConnectButton> with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _spinController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _pulseAnimation = Tween<double>(begin: 0.96, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _updateAnimations();
  }

  @override
  void didUpdateWidget(covariant AnimatedConnectButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.status != widget.status) {
      _updateAnimations();
    }
  }

  void _updateAnimations() {
    if (widget.status == VpnStatus.connecting) {
      _spinController.repeat();
    } else {
      _spinController.stop();
      _spinController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _spinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isConnected = widget.status == VpnStatus.connected;
    final isConnecting = widget.status == VpnStatus.connecting;

    final primaryColor = isConnected
        ? AppColors.connectedGreen
        : (isConnecting ? AppColors.connectingAmber : AppColors.primaryCyan);

    final glowColor = isConnected
        ? AppColors.connectedGreenGlow
        : (isConnecting ? AppColors.connectingAmberGlow : AppColors.primaryCyan.withOpacity(0.35));

    return Center(
      child: GestureDetector(
        onTap: widget.onTap,
        child: SizedBox(
          width: 240,
          height: 240,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer Pulsing Aura Ring
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: isConnected ? 1.08 : _pulseAnimation.value,
                    child: Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: glowColor,
                            blurRadius: isConnected ? 40 : 25,
                            spreadRadius: isConnected ? 8 : 4,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              // Rotating Dash Ring when Connecting
              if (isConnecting)
                AnimatedBuilder(
                  animation: _spinController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _spinController.value * 2 * math.pi,
                      child: Container(
                        width: 195,
                        height: 195,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: primaryColor.withOpacity(0.7),
                            width: 3,
                            strokeAlign: BorderSide.strokeAlignOutside,
                          ),
                        ),
                      ),
                    );
                  },
                ),

              // Outer Static Frosted Ring
              Container(
                width: 190,
                height: 190,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surfaceDark.withOpacity(0.4),
                  border: Border.all(
                    color: primaryColor.withOpacity(0.4),
                    width: 2,
                  ),
                ),
              ),

              // Inner Core Button
              Container(
                width: 155,
                height: 155,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isConnected
                        ? [const Color(0xFF00E676), const Color(0xFF00B074)]
                        : (isConnecting
                            ? [const Color(0xFFFFB300), const Color(0xFFF57C00)]
                            : [const Color(0xFF00D2FF), const Color(0xFF0066FF)]),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.5),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.power_settings_new_rounded,
                      size: 58,
                      color: isConnected || isConnecting ? Colors.black87 : Colors.white,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      isConnected ? 'STOP' : (isConnecting ? 'CONNECTING' : 'CONNECT'),
                      style: TextStyle(
                        color: isConnected || isConnecting ? Colors.black87 : Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
