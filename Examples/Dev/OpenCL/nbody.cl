__kernel void nbody_kern(
     float timeStep,
     float eps,
     __global float4* position1,
     __global float4* velocity1,
     __global float4* acceleration1,
     __global float4* position2,
     __global float4* velocity2,
     __global float4* acceleration2,
    __local float4* localPosition
) {
    const float4 dt = (float4)(timeStep,timeStep,timeStep,0.0f);

    int idxGlobal = get_global_id(0);
    int idxLocal = get_local_id(0);

    int globalSize = get_global_size(0);
    int localSize = get_local_size(0);
    int blocks = globalSize / localSize;
    
    float4 currentPosition = position1[idxGlobal];
    float4 currentVelocity = velocity1[idxGlobal];
    float4 currentAcceleration = acceleration1[idxGlobal];
    
    float4 newPosition = (float4)(0.0f,0.0f,0.0f,0.0f);
    float4 newVelocity = (float4)(0.0f,0.0f,0.0f,0.0f);
    float4 newAcceleration = (float4)(0.0f,0.0f,0.0f,0.0f);
    
    for(int currentBlock = 0; currentBlock < blocks; currentBlock++)
    {
        localPosition[idxLocal] = position1[currentBlock * localSize + idxLocal];
        barrier(CLK_LOCAL_MEM_FENCE);
        for(int idx = 0; idx < localSize; idx++)
        {
            float4 dir = localPosition[idx] - currentPosition;
            float invRadius = rsqrt(dir.x * dir.x + dir.y * dir.y + dir.z * dir.z + eps);
            float magnitude = localPosition[idx].w * invRadius * invRadius * invRadius;
            newAcceleration += magnitude * dir;
        }
        barrier(CLK_LOCAL_MEM_FENCE);
    }
    
    // leapfrog integration
    newPosition = currentPosition + currentVelocity * dt + 0.5f * currentAcceleration * dt * dt;
    newVelocity = currentVelocity + 0.5f * (currentAcceleration + newAcceleration) * dt;
    
    position2[idxGlobal] = newPosition;
    velocity2[idxGlobal] = newVelocity;
    acceleration2[idxGlobal] = newAcceleration;
}