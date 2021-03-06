---
layout: post
category: swing
folder: InternalFrameKeyInputOperation
title: JInternalFrameをキー入力で移動、リサイズする
tags: [JInternalFrame, JDesktopPane, InputMap]
author: aterai
pubdate: 2018-11-26T16:07:53+09:00
description: JInternalFrameのカーソルキー入力による移動、リサイズをテストします。
image: https://drive.google.com/uc?id=1xHC1_oVY3HI0SGcsd2zG2jsWp2CPMhMucg
comments: true
---
## 概要
`JInternalFrame`のカーソルキー入力による移動、リサイズをテストします。

{% download https://drive.google.com/uc?id=1xHC1_oVY3HI0SGcsd2zG2jsWp2CPMhMucg %}

## サンプルコード
<pre class="prettyprint"><code>InputMap im = desktop.getInputMap(JComponent.WHEN_ANCESTOR_OF_FOCUSED_COMPONENT);
int modifiers = InputEvent.CTRL_DOWN_MASK;
im.put(KeyStroke.getKeyStroke(KeyEvent.VK_UP, modifiers), "shrinkUp");
im.put(KeyStroke.getKeyStroke(KeyEvent.VK_DOWN, modifiers), "shrinkDown");
im.put(KeyStroke.getKeyStroke(KeyEvent.VK_LEFT, modifiers), "shrinkLeft");
im.put(KeyStroke.getKeyStroke(KeyEvent.VK_RIGHT, modifiers), "shrinkRight");
</code></pre>

## 解説
- `move`: `ctrl pressed F7`
    - <kbd>Ctrl+F7</kbd>で、現在フォーカスが存在する`JInternalFrame`をカーソルキーで移動可能なモードになる
    - `JInternalFrame`を完全に`JDesktopPane`の範囲外にカーソルキーで移動は不可
    - アイコン化したフレームを移動可能な`WindowsLookAndFeel`などの場合でも、カーソルキーでのアイコン移動は不可
    - <kbd>ESC</kbd>で移動モードは解除可能
        - 別`JInternalFrame`に選択が移動した場合も解除になる
- `resize`: `ctrl pressed F8`
    - <kbd>Ctrl+F8</kbd>で、現在フォーカスが存在する`JInternalFrame`をカーソルキーでリサイズ可能なモードになる
    - マウスによるリサイズが不可の場合でも、カーソルキーでのリサイズは可能
    - デフォルトでは拡大のみ可能で縮小`Action`にはキー入力が割り当てられていないため、このサンプルでは<kbd>Ctrl+UP</kbd>などで`JInternalFrame`の上辺を縮小方向にリサイズ可能になるよう設定している
        - `JInternalFrame`ではなく、`JDesktopPane`の`InputMap`に設定を追加する必要がある
    - `NimbusLookAndFeel`では、カーソルキーによるリサイズで`NullPointerException`が発生する
        - `1.8.0_192`、`11.0.1`ともにエラーになる

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>Exception in thread "AWT-EventQueue-0" java.lang.NullPointerException
    at java.desktop/javax.swing.plaf.basic.BasicDesktopPaneUI$Actions.actionPerformed(BasicDesktopPaneUI.java:472)
    at java.desktop/javax.swing.SwingUtilities.notifyAction(SwingUtilities.java:1810)
    at java.desktop/javax.swing.JComponent.processKeyBinding(JComponent.java:2900)
    at java.desktop/javax.swing.JComponent.processKeyBindings(JComponent.java:2962)
    at java.desktop/javax.swing.JComponent.processKeyEvent(JComponent.java:2862)
    at java.desktop/java.awt.Component.processEvent(Component.java:6409)
    at java.desktop/java.awt.Container.processEvent(Container.java:2263)
    at java.desktop/java.awt.Component.dispatchEventImpl(Component.java:5008)
    at java.desktop/java.awt.Container.dispatchEventImpl(Container.java:2321)
    at java.desktop/java.awt.Component.dispatchEvent(Component.java:4840)
    at java.desktop/java.awt.KeyboardFocusManager.redispatchEvent(KeyboardFocusManager.java:1950)
    at java.desktop/java.awt.DefaultKeyboardFocusManager.dispatchKeyEvent(DefaultKeyboardFocusManager.java:871)
    at java.desktop/java.awt.DefaultKeyboardFocusManager.preDispatchKeyEvent(DefaultKeyboardFocusManager.java:1140)
    at java.desktop/java.awt.DefaultKeyboardFocusManager.typeAheadAssertions(DefaultKeyboardFocusManager.java:1010)
    at java.desktop/java.awt.DefaultKeyboardFocusManager.dispatchEvent(DefaultKeyboardFocusManager.java:836)
    at java.desktop/java.awt.Component.dispatchEventImpl(Component.java:4889)
    at java.desktop/java.awt.Container.dispatchEventImpl(Container.java:2321)
    at java.desktop/java.awt.Window.dispatchEventImpl(Window.java:2772)
    at java.desktop/java.awt.Component.dispatchEvent(Component.java:4840)
    at java.desktop/java.awt.EventQueue.dispatchEventImpl(EventQueue.java:772)
    at java.desktop/java.awt.EventQueue$4.run(EventQueue.java:721)
    at java.desktop/java.awt.EventQueue$4.run(EventQueue.java:715)
    at java.base/java.security.AccessController.doPrivileged(Native Method)
    at java.base/java.security.ProtectionDomain$JavaSecurityAccessImpl.doIntersectionPrivilege(ProtectionDomain.java:85)
    at java.base/java.security.ProtectionDomain$JavaSecurityAccessImpl.doIntersectionPrivilege(ProtectionDomain.java:95)
    at java.desktop/java.awt.EventQueue$5.run(EventQueue.java:745)
    at java.desktop/java.awt.EventQueue$5.run(EventQueue.java:743)
    at java.base/java.security.AccessController.doPrivileged(Native Method)
    at java.base/java.security.ProtectionDomain$JavaSecurityAccessImpl.doIntersectionPrivilege(ProtectionDomain.java:85)
    at java.desktop/java.awt.EventQueue.dispatchEvent(EventQueue.java:742)
    at java.desktop/java.awt.EventDispatchThread.pumpOneEventForFilters(EventDispatchThread.java:203)
    at java.desktop/java.awt.EventDispatchThread.pumpEventsForFilter(EventDispatchThread.java:124)
    at java.desktop/java.awt.EventDispatchThread.pumpEventsForHierarchy(EventDispatchThread.java:113)
    at java.desktop/java.awt.EventDispatchThread.pumpEvents(EventDispatchThread.java:109)
    at java.desktop/java.awt.EventDispatchThread.pumpEvents(EventDispatchThread.java:101)
    at java.desktop/java.awt.EventDispatchThread.run(EventDispatchThread.java:90)
</code></pre>

- `close`: `ctrl pressed F4`
- `restore`: `ctrl pressed F5`
- `selectNextFrame`: `ctrl pressed F6`
- `minimize`: `ctrl pressed F9`
    - マウスによる最小化が不可の場合、キー入力による最小化も不可
- `maximize`: `ctrl pressed F10`
    - マウスによる最大化が不可の場合、キー入力による最大化も不可

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JComponentのKeyBinding一覧を取得する](https://ateraimemo.com/Swing/KeyBinding.html)
- [JDK-6603771 Nimbus L&F: Ctrl+F7 keybinding for JInternal Frame throws a NPE. - Java Bug System](https://bugs.openjdk.java.net/browse/JDK-6603771)
    - リサイズなどで`NullPointerException`になるのは`NimbusLookAndFeel`が入った最初からのバグらしい

<!-- dummy comment line for breaking list -->

## コメント
