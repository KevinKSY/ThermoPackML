
""" tensorflow code
# input layer
x = tf.placeholder(tf.float32, [None, 3])

# First layer
W1 = tf.Variable(tf.zeros([3,10]))
b1 = tf.Variable(tf.zeros([10]))
a1 = tf.nn.relu(tf.matmul(x, W1) + b1)

# Second layer
W2 = tf.Variable(tf.zeros([10,10]))
b2 = tf.Variable(tf.zeros([10]))
a2 = tf.nn.relu(tf.matmul(a1, W2) + b2)

# third layer
W3 = tf.Variable(tf.zeros([10,10]))
b3 = tf.Variable(tf.zeros([10]))
a3 = tf.nn.relu(tf.matmul(a2, W3) + b3)

# Output layer
W4 = tf.Variable(tf.zeros([10,10]))
b4 = tf.Variable(tf.zeros([10]))
y = tf.reduce_sum(tf.nn.relu(tf.matmul(a3, W4) + b4))

y_train = tf.placeholder(tf.float32)
loss = tf.reduce_mean(tf.reduce_sum(tf.square(y_train - y)))

train = tf.train.GradientDescentOptimizer(0.1).minimize(loss)

init = tf.global_variables_initializer()
"""