---
layout: post
title: FocusTraversalKeysに矢印キーを追加してフォーカス移動
category: swing
folder: FocusTraversalKeys
tags: [KeyboardFocusManager, Focus, Container]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2008-06-02

## FocusTraversalKeysに矢印キーを追加してフォーカス移動
デフォルトの<kbd>Tab</kbd>キーに加えて、矢印キーでもフォーカス移動できるように設定します。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTNHR5gShI/AAAAAAAAAaQ/KUE3fbR0bXo/s800/FocusTraversalKeys.png)

### サンプルコード
<pre class="prettyprint"><code>KeyboardFocusManager focusManager = KeyboardFocusManager.getCurrentKeyboardFocusManager();

Set&lt;AWTKeyStroke&gt; forwardKeys = new HashSet&lt;AWTKeyStroke&gt;(
    focusManager.getDefaultFocusTraversalKeys(KeyboardFocusManager.FORWARD_TRAVERSAL_KEYS));
forwardKeys.add(KeyStroke.getKeyStroke(KeyEvent.VK_RIGHT, 0));
forwardKeys.add(KeyStroke.getKeyStroke(KeyEvent.VK_DOWN,  0));
focusManager.setDefaultFocusTraversalKeys(KeyboardFocusManager.FORWARD_TRAVERSAL_KEYS, forwardKeys);

Set&lt;AWTKeyStroke&gt; backwardKeys = new HashSet&lt;AWTKeyStroke&gt;(
    focusManager.getDefaultFocusTraversalKeys(KeyboardFocusManager.BACKWARD_TRAVERSAL_KEYS));
backwardKeys.add(KeyStroke.getKeyStroke(KeyEvent.VK_LEFT, 0));
backwardKeys.add(KeyStroke.getKeyStroke(KeyEvent.VK_UP,   0));
focusManager.setDefaultFocusTraversalKeys(KeyboardFocusManager.BACKWARD_TRAVERSAL_KEYS, backwardKeys);
</code></pre>

### 解説
上記のサンプルでは、デフォルトのトラバーサルキー(<kbd>Tab</kbd>, <kbd>Shift+Tab</kbd>)に加えて、上下左右の矢印キーでもフォーカス移動できるようになっています。

- `KeyboardFocusManager.FORWARD_TRAVERSAL_KEYS`
    - `KeyEvent.VK_RIGHT`, `KeyEvent.VK_DOWN`
- `KeyboardFocusManager.BACKWARD_TRAVERSAL_KEYS`
    - `KeyEvent.VK_LEFT`, `KeyEvent.VK_UP`

<!-- dummy comment line for breaking list -->

- - - -
各`JFrame`や`JDialog`に別々の`FocusTraversalKeys`を設定したい場合は、`Container#setFocusTraversalKeys`を使用します。

<pre class="prettyprint"><code>Set&lt;AWTKeyStroke&gt; forwardKeys = new HashSet&lt;AWTKeyStroke&gt;(
    frame.getFocusTraversalKeys(KeyboardFocusManager.FORWARD_TRAVERSAL_KEYS));
forwardKeys.add(KeyStroke.getKeyStroke(KeyEvent.VK_RIGHT, 0));
forwardKeys.add(KeyStroke.getKeyStroke(KeyEvent.VK_DOWN,  0));
frame.setFocusTraversalKeys(KeyboardFocusManager.FORWARD_TRAVERSAL_KEYS, forwardKeys);
</code></pre>

### 参考リンク
- [KeyboardFocusManager#setDefaultFocusTraversalKeys](http://docs.oracle.com/javase/jp/6/api/java/awt/KeyboardFocusManager.html)
- [Container#setFocusTraversalKeys](http://docs.oracle.com/javase/jp/6/api/java/awt/Container.html)
- [How to Use the Focus Subsystem](http://docs.oracle.com/javase/tutorial/uiswing/misc/focus.html)
- [Focusの移動](http://terai.xrea.jp/Swing/FocusTraversal.html)

<!-- dummy comment line for breaking list -->

### コメント
